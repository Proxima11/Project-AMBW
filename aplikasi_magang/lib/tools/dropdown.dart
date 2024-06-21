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
    return Container(
      width: 300,
      child: Row(
        children: [
          Expanded(
            child: DropdownButtonHideUnderline(
              child: DropdownButtonFormField2<String>(
                decoration: InputDecoration(
                  fillColor: Colors.white,
                  filled: true,
                  contentPadding: const EdgeInsets.only(right: 10, left: 10),
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
                      borderSide: const BorderSide(width: 1, color: Colors.red),
                      borderRadius: BorderRadius.circular(10)),
                ),
                validator: validator,
                isExpanded: true,
                hint: Text(hintText ?? ''),
                // iconSize: 30,
                // iconEnabledColor: Colors.black,
                // icon: const Icon(
                //   Icons.arrow_drop_down_sharp,
                //   size: 15,
                // ),
                value: chosenValue,
                items: itemsList?.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: onChanged,
                // dropdownMaxHeight: 200,
                // dropdownDecoration: BoxDecoration(
                //   borderRadius: BorderRadius.circular(10),
                // ),
                // dropdownElevation: 1,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
