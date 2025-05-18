import 'package:flutter/material.dart';
import 'package:hotel_app/features/search_room/presentation/ui/search_room_screen.dart';

class CustomSearchAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  @override
  Size get preferredSize => Size.fromHeight(80);

  void navigateToSearch(BuildContext context, int isFiltered) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SearchRoomScreen(isFiltered: isFiltered),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 12),
      decoration: BoxDecoration(
        color: Color(0xFF6B4A2C),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(16),
          bottomRight: Radius.circular(16),
        ),
      ),
      child: Row(
        children: [
          IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          Expanded(
            child: GestureDetector(
              onTap: () => navigateToSearch(context, 0),
              child: Container(
                height: 48,
                padding: EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Khách sạn, địa điểm,...',
                        style: TextStyle(
                          color: Colors.brown.shade200,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    Icon(Icons.search, color: Color(0xFF6B4A2C)),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(width: 8),
          Container(
            height: 48,
            width: 48,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 4,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: IconButton(
              icon: Icon(Icons.tune, color: Color(0xFF6B4A2C)),
              onPressed: () => navigateToSearch(context, 1),
            ),
          ),
        ],
      ),
    );
  }
}
