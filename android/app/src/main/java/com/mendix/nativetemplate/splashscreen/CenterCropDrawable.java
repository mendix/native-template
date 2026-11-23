package com.mendix.nativetemplate.splashscreen;

import android.content.res.Resources;
import android.content.res.TypedArray;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.Canvas;
import android.graphics.ColorFilter;
import android.graphics.Matrix;
import android.graphics.Paint;
import android.graphics.PixelFormat;
import android.graphics.Rect;
import android.graphics.drawable.Drawable;
import android.util.AttributeSet;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import org.xmlpull.v1.XmlPullParser;
import org.xmlpull.v1.XmlPullParserException;

import java.io.IOException;

/**
 * Draws its {@code android:src} bitmap scaled uniformly to cover the bounds and centered, the
 * equivalent of {@link android.widget.ImageView.ScaleType#CENTER_CROP} (and of
 * {@code scaleAspectFill} used by the iOS launch screen).
 * <p>
 * A plain {@code <bitmap>} or {@code <inset>} cannot do this: they either scale both axes
 * independently (which distorts the image) or do not scale at all (which leaves bars on screens
 * larger than the bitmap). We need it for the splash window background, where the app's splash
 * image must keep its aspect ratio on every screen size and orientation.
 * <p>
 * Inflated by class name from {@code res/drawable/bootsplash.xml}, so it needs a public no-arg
 * constructor and a ProGuard keep rule.
 */
public class CenterCropDrawable extends Drawable {

    private final Paint paint = new Paint(Paint.FILTER_BITMAP_FLAG);
    private final Matrix matrix = new Matrix();
    @Nullable
    private Bitmap bitmap;

    public CenterCropDrawable() {
        super();
    }

    @Override
    public void inflate(@NonNull Resources r,
                        @NonNull XmlPullParser parser,
                        @NonNull AttributeSet attrs,
                        @Nullable Resources.Theme theme) throws XmlPullParserException, IOException {
        super.inflate(r, parser, attrs, theme);

        int[] attributes = new int[]{android.R.attr.src};
        TypedArray a = theme != null
                ? theme.obtainStyledAttributes(attrs, attributes, 0, 0)
                : r.obtainAttributes(attrs, attributes);

        int srcId;
        try {
            srcId = a.getResourceId(0, 0);
        } finally {
            a.recycle();
        }

        if (srcId == 0) {
            throw new XmlPullParserException("CenterCropDrawable requires an android:src attribute");
        }

        // Decode the closest density variant at its authored pixel size instead of letting the
        // framework rescale it for the device density first: we scale to the window ourselves,
        // so a second resampling pass would only cost memory and sharpness.
        BitmapFactory.Options options = new BitmapFactory.Options();
        options.inScaled = false;
        bitmap = BitmapFactory.decodeResource(r, srcId, options);

        updateMatrix(getBounds());
    }

    @Override
    protected void onBoundsChange(@NonNull Rect bounds) {
        updateMatrix(bounds);
    }

    private void updateMatrix(@NonNull Rect bounds) {
        if (bitmap == null || bounds.isEmpty() || bitmap.getWidth() == 0 || bitmap.getHeight() == 0) {
            return;
        }

        float scale = Math.max(
                bounds.width() / (float) bitmap.getWidth(),
                bounds.height() / (float) bitmap.getHeight()
        );

        matrix.setScale(scale, scale);
        matrix.postTranslate(
                bounds.left + (bounds.width() - bitmap.getWidth() * scale) / 2f,
                bounds.top + (bounds.height() - bitmap.getHeight() * scale) / 2f
        );
    }

    @Override
    public void draw(@NonNull Canvas canvas) {
        if (bitmap != null) {
            canvas.drawBitmap(bitmap, matrix, paint);
        }
    }

    @Override
    public void setAlpha(int alpha) {
        if (paint.getAlpha() != alpha) {
            paint.setAlpha(alpha);
            invalidateSelf();
        }
    }

    @Override
    public int getAlpha() {
        return paint.getAlpha();
    }

    @Override
    public void setColorFilter(@Nullable ColorFilter colorFilter) {
        paint.setColorFilter(colorFilter);
        invalidateSelf();
    }

    @Nullable
    @Override
    public ColorFilter getColorFilter() {
        return paint.getColorFilter();
    }

    // Covering the bounds with an opaque bitmap lets the framework skip drawing whatever is
    // underneath; without a bitmap we draw nothing and must not claim to be opaque.
    @Override
    public int getOpacity() {
        if (bitmap == null || paint.getAlpha() < 255 || bitmap.hasAlpha()) {
            return PixelFormat.TRANSLUCENT;
        }
        return PixelFormat.OPAQUE;
    }
}
