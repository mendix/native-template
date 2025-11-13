#!/bin/bash

# Script to update Android styles.xml and remove react-native-edge-to-edge package
# Usage: ./update-styles-and-remove-edge-to-edge.sh

set -e  # Exit on error

echo "======================================"
echo "Updating Android Styles & Removing Edge-to-Edge Package"
echo "======================================"

# Define the styles.xml path
STYLES_FILE="android/app/src/main/res/values/styles.xml"

# Check if styles.xml exists
if [ ! -f "$STYLES_FILE" ]; then
    echo "Error: $STYLES_FILE not found!"
    exit 1
fi

echo ""
echo "Step 1: Updating styles.xml..."
cat > "$STYLES_FILE" << 'EOF'
<resources>

    <!-- Base light application theme. -->
    <style name="AppTheme" parent="Theme.AppCompat.Light.NoActionBar">
        <!-- Customize your theme here. -->
        <item name="android:windowDisablePreview">true</item>
        <item name="android:windowIsTranslucent">true</item>
        <item name="android:editTextStyle">@style/MendixEditText</item>
        <item name="android:windowOptOutEdgeToEdgeEnforcement">true</item>
    </style>
    <!-- Base dark application theme. -->
    <style name="AppTheme_Dark" parent="Theme.AppCompat.DayNight.NoActionBar">
        <!-- Customize your theme here. -->
        <item name="android:windowDisablePreview">true</item>
        <item name="android:windowIsTranslucent">true</item>
        <item name="android:editTextStyle">@style/MendixEditText</item>
        <item name="android:windowOptOutEdgeToEdgeEnforcement">true</item>
    </style>


    <style name="MendixEditText" parent="Widget.AppCompat.EditText">
        <item name="android:background">@android:color/transparent</item>
    </style>

    <!-- BootSplash theme. -->
    <style name="BootTheme" parent="Theme.AppCompat.Light.NoActionBar">
        <item name="android:windowBackground">@drawable/splash_screen</item>
    </style>

</resources>
EOF
echo "✓ styles.xml updated successfully"

echo ""
echo "Step 2: Updating gradle.properties..."
GRADLE_PROPERTIES="android/gradle.properties"
if [ -f "$GRADLE_PROPERTIES" ]; then
    if grep -q "edgeToEdgeEnabled=true" "$GRADLE_PROPERTIES"; then
        sed -i.bak 's/edgeToEdgeEnabled=true/edgeToEdgeEnabled=false/g' "$GRADLE_PROPERTIES"
        rm "${GRADLE_PROPERTIES}.bak"
        echo "✓ gradle.properties updated (edgeToEdgeEnabled=false)"
    else
        echo "⚠ edgeToEdgeEnabled=true not found in gradle.properties"
    fi
else
    echo "⚠ $GRADLE_PROPERTIES not found, skipping"
fi

echo ""
echo "Step 3: Removing react-native-edge-to-edge package..."
if [ -f "package.json" ]; then
    if grep -q '"react-native-edge-to-edge"' package.json; then
        npm uninstall react-native-edge-to-edge
        echo "✓ react-native-edge-to-edge package removed successfully"
    else
        echo "⚠ react-native-edge-to-edge package not found in package.json"
    fi
else
    echo "Error: package.json not found!"
    exit 1
fi

echo ""
echo "======================================"
echo "✓ All tasks completed successfully!"
echo "======================================"
echo ""
echo "Summary:"
echo "  - styles.xml updated"
echo "  - gradle.properties updated (edgeToEdgeEnabled=false)"
echo "  - react-native-edge-to-edge package removed"
echo ""
