document.addEventListener("DOMContentLoaded", function () {
  // Fetch version compatibility data from native_template_versions.json
  fetch("native_template_versions.json")
    .then((response) => response.json())
    .then((data) => {
      const tableBody = document.getElementById("versionTableBody");

      // Process each version entry
      Object.entries(data).forEach(([mendixVersion, details]) => {
        const row = document.createElement("tr");

        // Create cells for each piece of information
        const mendixVersionCell = document.createElement("td");
        mendixVersionCell.textContent = mendixVersion;

        const minNativeTemplateCell = document.createElement("td");
        minNativeTemplateCell.textContent = details.min;

        const maxNativeTemplateCell = document.createElement("td");
        maxNativeTemplateCell.textContent = details.max;

        const androidSdkCell = document.createElement("td");
        androidSdkCell.textContent = `Min: ${details.androidSdk.min}\nCompile: ${details.androidSdk.compile}\nTarget: ${details.androidSdk.target}`;

        const gradleCell = document.createElement("td");
        gradleCell.textContent = details.gradle;

        const iosMinSdkCell = document.createElement("td");
        iosMinSdkCell.textContent = details.iosMinSdk;

        // Append cells to row
        row.appendChild(mendixVersionCell);
        row.appendChild(minNativeTemplateCell);
        row.appendChild(maxNativeTemplateCell);
        row.appendChild(androidSdkCell);
        row.appendChild(gradleCell);
        row.appendChild(iosMinSdkCell);

        // Append row to table
        tableBody.appendChild(row);
      });
    })
    .catch((error) => {
      console.error("Error loading version data:", error);
      const tableBody = document.getElementById("versionTableBody");
      const row = document.createElement("tr");
      const cell = document.createElement("td");
      cell.colSpan = 6;
      cell.textContent = "Error loading version data. Please try again later.";
      row.appendChild(cell);
      tableBody.appendChild(row);
    });
});
