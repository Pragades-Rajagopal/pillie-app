import 'package:flutter/material.dart';
import 'package:pillie/models/pill_model.dart';

class PillCard extends StatelessWidget {
  const PillCard({super.key, required this.pills});

  final List<PillModel> pills;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      padding: const EdgeInsets.only(bottom: 4.0),
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 1,
      ),
      itemCount: pills.length,
      itemBuilder: (context, index) {
        final pill = pills[index];
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: Colors.grey[400]!,
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
            border: Border.all(color: Colors.grey[200]!),
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${pill.count ?? 0}',
                    style: const TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'Day',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: pill.day == true
                              ? Colors.black87
                              : Colors.grey[300],
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Noon',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: pill.noon == true
                              ? Colors.black87
                              : Colors.grey[300],
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Night',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: pill.night == true
                              ? Colors.black87
                              : Colors.grey[300],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Expanded(
                child: Text(
                  pill.name ?? 'Medicine',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '${pill.resetDays ?? 0} days left to refill',
                style: const TextStyle(fontSize: 14, color: Colors.black54),
              ),
            ],
          ),
        );
      },
    );
  }
}
