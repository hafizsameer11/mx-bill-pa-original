import 'package:bill_payment/utils/app_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

class CustomDropdownButton extends StatefulWidget {
  final List<String> items;
  final String? selectedItem;
  final String labelText;
  final String hintText;
  final ValueChanged<String?> onChanged;
  final String? Function(String?)? validator;
  final TextEditingController searchController;

  const CustomDropdownButton({
    Key? key,
    required this.items,
    this.selectedItem,
    required this.labelText,
    required this.hintText,
    required this.onChanged,
    this.validator,
    required this.searchController,
  }) : super(key: key);

  @override
  _CustomDropdownButtonState createState() => _CustomDropdownButtonState();
}

class _CustomDropdownButtonState extends State<CustomDropdownButton> {
  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField2<String>(
      isExpanded: true,
      decoration: InputDecoration(
        labelText: widget.labelText,
        labelStyle: GoogleFonts.jost(
          color: CustomColors.getTextColor(),
        ),
        contentPadding: EdgeInsets.all(14.w),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.w),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.w),
          borderSide: BorderSide(
            color: CustomColors.primaryColor,
            width: 1.w,
          ),
        ),
        errorStyle: GoogleFonts.jost(color: CustomColors.secondaryColor),
        filled: true,
        fillColor: CustomColors.getInputColor(),
      ),
      items: widget.items
          .map((item) => DropdownMenuItem<String>(
                value: item,
                child: Text(
                  item,
                  style: GoogleFonts.jost(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w400,
                    color: CustomColors.getTextColor(),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ))
          .toList(),
      validator: widget.validator,
      value: widget.selectedItem,
      onChanged: widget.onChanged,
      buttonStyleData: ButtonStyleData(
        padding: EdgeInsets.all(0.w),
      ),
      iconStyleData: IconStyleData(
        icon: Icon(
          CupertinoIcons.chevron_down,
          color: CustomColors.getTextColor(),
        ),
        iconSize: 18,
      ),
      dropdownStyleData: DropdownStyleData(
        maxHeight: 300,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14.w),
          color: CustomColors.getContainerColor(),
        ),
        scrollbarTheme: ScrollbarThemeData(
          radius: const Radius.circular(40),
          thickness: WidgetStateProperty.all(3),
          thumbVisibility: WidgetStateProperty.all(true),
          thumbColor: WidgetStatePropertyAll(CustomColors.getBorderColor()),
        ),
      ),
      menuItemStyleData: MenuItemStyleData(
        padding: EdgeInsets.only(left: 14.w),
      ),
      dropdownSearchData: DropdownSearchData(
        searchController: widget.searchController,
        searchInnerWidgetHeight: 50,
        searchInnerWidget: Container(
          margin: EdgeInsets.only(top: 12.h, left: 12.w, right: 12.w),
          child: TextFormField(
            controller: widget.searchController,
            style: GoogleFonts.getFont(
              'Jost',
              textStyle: TextStyle(
                fontSize: 16.sp,
              ),
            ),
            decoration: InputDecoration(
              hintText: widget.hintText,
              hintStyle: GoogleFonts.jost(
                color: CustomColors.getTextColor(),
              ),
              contentPadding: EdgeInsets.all(14.w),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.w),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.w),
                borderSide: BorderSide(
                  color: CustomColors.primaryColor,
                  width: 1.w,
                ),
              ),
              errorStyle: GoogleFonts.jost(color: CustomColors.secondaryColor),
              filled: true,
              fillColor: CustomColors.getInputColor(),
            ),
          ),
        ),
        searchMatchFn: (item, searchValue) {
          return item.value.toString().toLowerCase().contains(searchValue.toLowerCase());
        },
      ),
      onMenuStateChange: (isOpen) {
        if (!isOpen) {
          widget.searchController.clear();
        }
      },
    );
  }
}
