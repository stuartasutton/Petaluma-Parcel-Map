# Petaluma Assessor Parcel Atlas

Explore existing land use in Petaluma using locally interpreted Sonoma County Assessor use classifications.

- [Current working version](Assessor-parcel-map-2026-11-24.html) · November 24, 2026
- [Previous working version](Asessor-parcel-map-2026-11-02.html) · November 2, 2026
- [Historical reference implementation](reference/petaluma_parcels_map.html)

Download the current HTML file and open it directly in a current Chrome or Safari browser. The embedded parcel map needs no local server. The optional County street basemap needs an internet connection.

## APN search

Enter the parcel APN in the search field and submit. Hyphens are optional and leading zeroes matter. The map centers and zooms to the matching parcel, highlights it, and opens its data popup. If multiple records share the APN, choose a record to open it. Selecting another search result replaces the popup and highlight.

## November 24 refinements

- Residential parcels and the matching legend swatch use pale green (`#addbaf`).
- Parcel outlines use dark grey (`#4a4a4a`) at 85% opacity with a width that increases from 0.25 px at citywide zoom to 0.7 px for neighborhood and parcel views. Selection highlighting and vacancy context styling are preserved.
- Clicking a parcel opens its data popup and highlights it at the current map center and zoom.
- The November 2 build contains no APN or named-place labels on the map, so the requested label darkening could not be applied. APNs are still available in search and parcel details.
