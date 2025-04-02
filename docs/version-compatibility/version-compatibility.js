document.addEventListener('DOMContentLoaded', function() {
    fetch('../../mendix_version.json')
        .then(response => response.json())
        .then(data => {
            const tbody = document.getElementById('version-data');
            Object.entries(data).forEach(([mendixVersion, versions]) => {
                const row = document.createElement('tr');
                row.innerHTML = `
                    <td>${mendixVersion}</td>
                    <td>${versions.min}</td>
                    <td>${versions.max}</td>
                `;
                tbody.appendChild(row);
            });
        })
        .catch(error => {
            console.error('Error loading version data:', error);
            document.getElementById('version-data').innerHTML = `
                <tr>
                    <td colspan="3" style="text-align: center; color: red;">
                        Error loading version data. Please try again later.
                    </td>
                </tr>
            `;
        });
}); 