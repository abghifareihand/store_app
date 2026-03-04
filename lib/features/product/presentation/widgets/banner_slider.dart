import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:store_app/core/theme/app_colors.dart';

class BannerSlider extends StatefulWidget {
  final List<String> items;
  const BannerSlider({super.key, required this.items});

  @override
  State<BannerSlider> createState() => _BannerSliderState();
}

class _BannerSliderState extends State<BannerSlider> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CarouselSlider(
          items: widget.items
              .map(
                (e) => Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Image.asset(
                    e,
                    height: 206.0,
                    width: MediaQuery.of(context).size.width,
                    fit: BoxFit.fill,
                  ),
                ),
              )
              .toList(),
          options: CarouselOptions(
            autoPlay: true,
            aspectRatio: 315 / 152,
            viewportFraction: 1,
            onPageChanged: (index, reason) {
              setState(() {
                _currentIndex = index;
              });
            },
          ),
        ),
        const SizedBox(height: 8.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: widget.items.asMap().entries.map((entry) {
            return AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.symmetric(horizontal: 2),
              width: _currentIndex == entry.key ? 6 : 6,
              height: _currentIndex == entry.key ? 6 : 6,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _currentIndex == entry.key ? AppColors.primary : Colors.grey,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
