import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class CommonDropdownButton extends StatelessWidget {
  String? chosenValue = 'Role';
  final String? hintText;
  final List<String>? itemsList;
  final Function(dynamic value)? onChanged;
  final String? Function(String?)? validator;
  CommonDropdownButton(
      {Key? key,
      this.chosenValue,
      this.hintText,
      this.itemsList,
      this.onChanged,
      this.validator})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double _fontSize = screenWidth * 0.04; // Adjust multiplier as needed
    return Container(
      width: 300,
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: DropdownButtonHideUnderline(
              child: Expanded(
                child: DropdownButtonFormField2<String>(
                  decoration: InputDecoration(
                    fillColor: Colors.white,
                    filled: true,
                    contentPadding: const EdgeInsets.only(right: 10, left: 10),
                    constraints: BoxConstraints(
                      minHeight: 50, // Minimum height
                    ),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black, width: 1.0),
                      borderRadius: BorderRadius.all(
                        Radius.circular(10.0),
                      ),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black, width: 1.0),
                      borderRadius: BorderRadius.all(
                        Radius.circular(10.0),
                      ),
                    ),
                    enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black, width: 1.0),
                      borderRadius: BorderRadius.all(
                        Radius.circular(10.0),
                      ),
                    ),
                    errorBorder: OutlineInputBorder(
                        borderSide:
                            const BorderSide(width: 1, color: Colors.red),
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  validator: validator,
                  isDense: true,
                  isExpanded: true,
                  hint: Text(
                    chosenValue == null
                        ? hintText ?? ''
                        : '', // Display hint only if chosenValue is null
                    style: TextStyle(
                        color: chosenValue == null
                            ? Colors.black54
                            : Colors.black), // Hint text color
                  ),
                  iconStyleData: const IconStyleData(
                    icon: Icon(
                      Icons.arrow_drop_down,
                      color: Colors.black45,
                    ),
                    iconSize: 30,
                  ),
                  // iconSize: 30,
                  // iconEnabledColor: Colors.black,
                  // icon: const Icon(
                  //   Icons.arrow_drop_down_sharp,
                  //   size: 15,
                  // ),
                  value: chosenValue,
                  items:
                      itemsList?.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Expanded(
                        child: Container(
                          constraints: BoxConstraints(
                              minHeight: 100, maxHeight: 200 // Minimum height
                              ),
                          child: Text(
                            value,
                            softWrap: true,
                            maxLines: null,
                            // overflow: TextOverflow.visible,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value == 'Reset') {
                      chosenValue = null; // Set the value to null for reset
                    } else {
                      chosenValue = value;
                    }
                    onChanged?.call(chosenValue);
                  },
                  dropdownStyleData: DropdownStyleData(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      maxHeight: 300),
                  menuItemStyleData: screenWidth > 600
                      ? const MenuItemStyleData(
                          padding:
                              EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          height: 60)
                      : const MenuItemStyleData(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          height: 100),
                  // dropdownMaxHeight: 200,
                  // dropdownDecoration: BoxDecoration(
                  //   borderRadius: BorderRadius.circular(10),
                  // ),
                  // dropdownElevation: 1,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
