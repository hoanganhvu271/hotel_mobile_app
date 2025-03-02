import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hotel_app/features/example/presentation/provider/example_provider.dart';

class ExampleScreen extends ConsumerWidget {
  const ExampleScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ref.watch(exampleViewmodel);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Example Screen'),
      ),
      body: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            data.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error) => Center(child: Text(error)),
              success: (data) => ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                itemCount: data.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  final item = data[index];
                  return Text(item.id.toString() + '----' + item.title);
                },
              ),
              none: () => const Center(child: Text('Click button to have data')),
              orElse: () => const Center(child: Text('Click button to have data')),
            ),
            ElevatedButton(
              onPressed: () {
                ref.read(exampleViewmodel.notifier).getExample();
              },
              child: const Text('Get Example'),
            ),
          ],
        ),
      )
    );
  }
}
