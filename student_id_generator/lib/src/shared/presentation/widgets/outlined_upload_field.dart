import 'package:flutter/material.dart';
import 'package:student_id_generator/src/core/constants/app_strings.dart';

class OutlinedUploadField extends StatelessWidget {
  const OutlinedUploadField({
    super.key,
    required this.label,
    this.hint,
    this.onTap,
    this.trailing,
  });

  final String label;
  final String? hint;
  final VoidCallback? onTap;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: theme.colorScheme.outlineVariant),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: theme.colorScheme.outlineVariant),
              ),
              child: Text(AppStrings.chooseFile,
                  style: theme.textTheme.labelMedium),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                label,
                style: theme.textTheme.bodyMedium,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (hint != null) ...[
              const SizedBox(width: 12),
              Text(
                hint!,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.textTheme.bodySmall?.color?.withOpacity(0.6),
                ),
              ),
            ],
            if (trailing != null) ...[const SizedBox(width: 12), trailing!],
          ],
        ),
      ),
    );
  }
}
