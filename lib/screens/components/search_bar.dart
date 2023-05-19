import 'package:flutter/material.dart';
import 'package:SmartShop/custom_widgets/CustomText.dart';
import 'package:SmartShop/custom_widgets/custom_filter.dart';

class CustomSearchBar extends StatefulWidget {
  final Function(String) onSearch;
  final Function(DateTime?, DateTime?)? onFilter;

  const CustomSearchBar({Key? key, required this.onSearch, this.onFilter}) : super(key: key);

  @override
  _CustomSearchBarState createState() => _CustomSearchBarState();
}

class _CustomSearchBarState extends State<CustomSearchBar> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Flexible(
          flex: 10,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: TextField(
              controller: _controller,
              decoration: const InputDecoration(
                hintText: 'Search',
                border: OutlineInputBorder(),
                suffixIcon: Icon(Icons.search),
              ),
              onChanged: widget.onSearch,
            ),
          ),
        ),
        Flexible(
          flex: 1,
          child: IconButton(
            onPressed: () => showDialog(
              context: context,
              builder: (_) => AlertDialog(
                title: const CustomText(placeholder: 'Filter by date', textAlign: TextAlign.center, fontSize: 20, fontWeight: FontWeight.bold),
                content: FractionallySizedBox(
                  heightFactor: 0.3,
                  child: CustomFilterWidget(
                    onFilter: widget.onFilter!,
                  ),
                ),
              ),
            ),
            icon: const Icon(Icons.filter_list),
          ),
        ),
      ],
    );
  }
}
