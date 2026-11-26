# Petaluma Assessor Parcel Atlas

Explore existing land use in Petaluma using locally interpreted Sonoma County Assessor use classifications.

- [Current working version](Assessor-parcel-map-2026-11-24.html) · November 24, 2026
- [Previous working version](Asessor-parcel-map-2026-11-02.html) · November 2, 2026
- [Historical reference implementation](reference/petaluma_parcels_map.html)

## Opening and Closing the Map on macOS

1. Install [Python 3](https://www.python.org/downloads/macos/) and Google Chrome. No Python packages are required.
2. Open the repository folder in Finder and double-click `start-map.command`. The launcher waits for the server, then opens the current map in Chrome. You can close the Terminal window after Chrome opens. Double-clicking again reuses the running server.
3. Double-click `stop-map.command` in the same folder to stop the Parcel Map server.

The local map URL is **http://127.0.0.1:8001/Assessor-parcel-map-2026-11-24.html**. The Parcel Map listens on port **8001** on your Mac. The Value Map can run at the same time on port **8000**. The optional County street basemap requires an internet connection.

To create a desktop shortcut, select `start-map.command` in Finder, choose **File → Make Alias**, and drag the alias to your Desktop. Keep the original in the repository folder.

### Troubleshooting

- **Finder says the file cannot be executed.** Open Terminal in the repository folder and run `chmod +x start-map.command stop-map.command`. If macOS asks you to confirm opening the script, use Control-click → **Open**.
- **Port 8001 is already in use.** Close the app using that port and run the launcher again.
- **Server did not respond.** In Finder press **Command–Shift–.** to show hidden files and open `.map-server.log` in the repository folder. If a start or stop was interrupted and the launcher reports a lock error, remove the empty `.map-server.lock` folder after both scripts have exited.
- **Chrome did not open.** Install Chrome or paste the local URL into your browser while the server is running. The HTML file can also be opened directly in Chrome or Safari.

## APN search

Enter the parcel APN in the search field and submit. Hyphens are optional and leading zeroes matter. The map centers and zooms to the matching parcel, highlights it, and opens its data popup. If multiple records share the APN, choose a record to open it. Selecting another search result replaces the popup and highlight.

## November 24 refinements

- Residential parcels and the matching legend swatch use pale green (`#addbaf`).
- Parcel outlines use dark grey (`#4a4a4a`) at 85% opacity with a width that increases from 0.25 px at citywide zoom to 0.7 px for neighborhood and parcel views. Selection highlighting and vacancy context styling are preserved.
- Clicking a parcel opens its data popup and highlights it at the current map center and zoom.
- The November 2 build contains no APN or named-place labels on the map, so the requested label darkening could not be applied. APNs are still available in search and parcel details.
