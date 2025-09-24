import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:botanic_guide_a_tool_for_garden_planters/main.dart' as app;

void main() {
  // Note: For full integration tests, you'll need to add integration_test package to pubspec.yaml
  // For now, these are widget tests that can test UI interactions

  group('Flutter-Backend Integration Tests', () {
    testWidgets('Add planting workflow - full integration', (WidgetTester tester) async {
      // Start the app
      app.main();
      await tester.pumpAndSettle();

      // Navigate to add planting page
      // Update these selectors based on your actual Flutter app structure
      await tester.tap(find.text('Add Planting'));
      await tester.pumpAndSettle();

      // Fill planting form
      await tester.enterText(find.byKey(const Key('date_planted_field')), '2025-09-17');
      await tester.enterText(find.byKey(const Key('number_planted_field')), '5');
      
      // Select dropdown values (adjust based on your UI)
      await tester.tap(find.byKey(const Key('variety_dropdown')));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Test Variety').last);
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const Key('zone_dropdown')));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Zone 1').last);
      await tester.pumpAndSettle();

      // Add comments
      await tester.enterText(find.byKey(const Key('comments_field')), 'Flutter integration test planting');

      // Submit the form
      await tester.tap(find.byKey(const Key('submit_planting_button')));
      await tester.pumpAndSettle();

      // Verify success message appears
      expect(find.text('Planting added successfully'), findsOneWidget);
      
      // Wait for navigation back to list
      await tester.pumpAndSettle();

      // Verify the new planting appears in the list
      expect(find.text('Flutter integration test planting'), findsOneWidget);
    });

    testWidgets('View users workflow - frontend display', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Navigate to users list
      await tester.tap(find.text('Users'));
      await tester.pumpAndSettle();

      // Verify users list loads
      expect(find.byType(ListView), findsOneWidget);
      
      // Check that user data is displayed (based on your backend test expectations)
      // These should match the users that exist in your database
      expect(find.textContaining('User'), findsAtLeast(1));
    });

    testWidgets('View species workflow - frontend display', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Navigate to species list
      await tester.tap(find.text('Species'));
      await tester.pumpAndSettle();

      // Verify species list loads
      expect(find.byType(ListView), findsOneWidget);
      
      // Check that species data is displayed
      expect(find.textContaining('Species'), findsAtLeast(1));
    });

    testWidgets('Add acquisition workflow - full integration', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Navigate to add acquisition page
      await tester.tap(find.text('Add Acquisition'));
      await tester.pumpAndSettle();

      // Fill acquisition form
      await tester.enterText(find.byKey(const Key('acquisition_date_field')), '2025-09-17');
      await tester.enterText(find.byKey(const Key('generation_number_field')), '1');
      
      // Select variety and supplier dropdowns
      await tester.tap(find.byKey(const Key('variety_dropdown')));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Test Variety').last);
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const Key('supplier_dropdown')));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Test Supplier').last);
      await tester.pumpAndSettle();

      // Toggle landscape only checkbox
      await tester.tap(find.byKey(const Key('landscape_only_checkbox')));
      await tester.pumpAndSettle();

      // Submit the form
      await tester.tap(find.byKey(const Key('submit_acquisition_button')));
      await tester.pumpAndSettle();

      // Verify success message
      expect(find.text('Acquisition added successfully'), findsOneWidget);
    });

    testWidgets('Add conservation status workflow', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Navigate to manage conservation status
      await tester.tap(find.text('Manage Conservation Status'));
      await tester.pumpAndSettle();

      // Add new conservation status
      await tester.tap(find.byKey(const Key('add_conservation_status_button')));
      await tester.pumpAndSettle();

      // Fill the status field
      await tester.enterText(find.byKey(const Key('status_field')), 'Endangered');

      // Submit
      await tester.tap(find.byKey(const Key('submit_status_button')));
      await tester.pumpAndSettle();

      // Verify success
      expect(find.text('Conservation status added successfully'), findsOneWidget);
    });

    testWidgets('Add container type workflow', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Navigate to manage container types
      await tester.tap(find.text('Manage Container Types'));
      await tester.pumpAndSettle();

      // Add new container type
      await tester.tap(find.byKey(const Key('add_container_type_button')));
      await tester.pumpAndSettle();

      // Fill the container type field
      await tester.enterText(find.byKey(const Key('container_type_field')), 'Test Tray');

      // Submit
      await tester.tap(find.byKey(const Key('submit_container_type_button')));
      await tester.pumpAndSettle();

      // Verify success
      expect(find.text('Container type added successfully'), findsOneWidget);
    });

    testWidgets('Error handling - invalid data submission', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Navigate to add planting
      await tester.tap(find.text('Add Planting'));
      await tester.pumpAndSettle();

      // Submit form without filling required fields
      await tester.tap(find.byKey(const Key('submit_planting_button')));
      await tester.pumpAndSettle();

      // Verify error messages appear
      expect(find.textContaining('required'), findsAtLeast(1));
      
      // Or verify specific error messages based on your validation
      expect(find.text('Date planted is required'), findsOneWidget);
    });

    testWidgets('Network error handling', (WidgetTester tester) async {
      // This test would require mocking network failures
      // You might need to inject a test HTTP client or use network interception
      
      app.main();
      await tester.pumpAndSettle();

      // Simulate network error scenario
      // This would depend on how your app handles network errors
      
      // Navigate to a page that makes API calls
      await tester.tap(find.text('Users'));
      await tester.pumpAndSettle();

      // If network is down, verify appropriate error message
      // expect(find.text('Unable to connect to server'), findsOneWidget);
    });

    testWidgets('Search and filter functionality', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Navigate to species list
      await tester.tap(find.text('Species'));
      await tester.pumpAndSettle();

      // Use search functionality
      await tester.enterText(find.byKey(const Key('search_field')), 'Test Species');
      await tester.pumpAndSettle();

      // Verify filtered results
      expect(find.textContaining('Test Species'), findsAtLeast(1));

      // Clear search
      await tester.tap(find.byKey(const Key('clear_search_button')));
      await tester.pumpAndSettle();

      // Verify all results are shown again
      expect(find.byType(ListTile), findsAtLeast(2));
    });
  });
}