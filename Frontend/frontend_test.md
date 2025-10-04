# Frontend Testing
> Aim: To test whether the screens are functional and responsive in both Android and iOS devices. 

## Troubleshooting
> Preliminary testing has been done. "Safe Area" has now been activated to ensure that content can be displayed without being obstructed by notches, cameras, or indicator bars. 
> All 47 screens should be functional on both operating systems given the application is being developed using Flutter. If this is incorrect, let the team know ASAP.

First, run code in branch "flutterflow" on your device. Launch application. Open `Inspect` on Browser.

For each screen in `test_notes.md`:
1. Set "Dimensions: Responsive"
2. Resize display. Does the screens appear to be responsive? Can all functionality be utilised on a reasonable screen size?
3. Rotate screen. 
4. Again, resize display. Does the screens appear to be responsive? Can all functionality be utilised on a reasonable screen size?
5. Test a few different devices (tablet, desktop, mobile. Android and iOS devices) through "Inspect" - both portrait and landscape orientations. Emphasising on smaller screens. Does the screens appear to be responsive? Can all functionality be utilised on a reasonable screen size?
6. Fix any minor errors. Major errors? Let the team know :)
7. Record results in `test_notes.md`. Sort screens into different categories.

## Next steps:
- Best case scenario: Push to Main with all current Flutter screens. No future modifications needed.
- Minor fixes required in current Flutter screens: Implement these fixes, push to GitHub, and notify the group.
- Worst case scenario: Major fixes required. Let the group know. Copy existing material into separate project, push all other screens to main, and fix these screens simultaneously with backend development. 