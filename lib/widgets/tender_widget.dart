import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/tender.dart';
import 'package:photo_view/photo_view.dart';


class TenderWidget extends StatelessWidget {
  final Tender tender;

  const TenderWidget({super.key, required this.tender});

void _showAttachmentsDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Attachments'),
        content: SizedBox(
          width: double.maxFinite,
          child: tender.attachments.isNotEmpty
              ? ListView.builder(
                  shrinkWrap: true,
                  itemCount: tender.attachments.length,
                  itemBuilder: (context, index) {
                    final url = tender.attachments[index];
                    final fileName = url.split('/').last;
                    final fileExtension = fileName.split('.').last.toLowerCase();

                    IconData icon;
                    if (['jpg', 'jpeg', 'png', 'gif'].contains(fileExtension)) {
                      icon = Icons.image;
                    } else if (fileExtension == 'pdf') {
                      icon = Icons.picture_as_pdf;
                    } else if (['doc', 'docx'].contains(fileExtension)) {
                      icon = Icons.description;
                    } else {
                      icon = Icons.attach_file;
                    }

                    return ListTile(
                      leading: Icon(icon, color: Colors.blue),
                      title: Tooltip(
                      message: fileName,
                      child: Text(
                        fileName,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: const TextStyle(fontSize: 14),
                      ),
                    ),
                      onTap: () async {
                        if (['jpg', 'jpeg', 'png', 'gif'].contains(fileExtension)) {
                          showDialog(
                            context: context,
                            builder: (_) => Dialog(
                              child: PhotoView(
                                imageProvider: NetworkImage(url),
                              ),
                            ),
                          );
                        } else {
                          final uri = Uri.parse(url);
                          if (await canLaunchUrl(uri)) {
                            await launchUrl(uri, mode: LaunchMode.externalApplication);
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Could not open attachment')),
                            );
                          }
                        }
                      },
                    );
                  },
                )
              : const Text('No attachments available.'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      );
    },
  );
}

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
      child: ExpansionTile(
        title: Text(
          'Tender ID: ${tender.tenderId}',
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 8, left: 16, right: 16),
            child: tender.attachments.isNotEmpty
                ? Align(
                    alignment: Alignment.centerLeft,
                    child: ElevatedButton.icon(
                      onPressed: () => _showAttachmentsDialog(context),
                      icon: const Icon(Icons.attach_file),
                      label: const Text('See Attachments'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue.shade600,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        textStyle: GoogleFonts.poppins(fontSize: 14),
                      ),
                    ),
                  )
                : const SizedBox.shrink(),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Provider: ${tender.provider}',
                  style: GoogleFonts.poppins(fontSize: 14, color: Colors.black54),
                ),
                const SizedBox(height: 4),
                Text(
                  'Economic Value: ${tender.economicValue}',
                  style: GoogleFonts.poppins(fontSize: 14, color: Colors.black54),
                ),
                const SizedBox(height: 8),
                if (tender.content.isNotEmpty) ...[
                  Text(
                    'Procedure Details:',
                    style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    tender.content['procedure_name'] ?? 'No procedure name',
                    style: GoogleFonts.poppins(fontSize: 14, fontStyle: FontStyle.italic),
                  ),
                  Text(
                    'Code: ${tender.content['tender_code'] ?? 'N/A'}',
                    style: GoogleFonts.poppins(fontSize: 13, color: Colors.black87),
                  ),
                  Text(
                    'Authority: ${tender.content['contracting_authority'] ?? 'N/A'}',
                    style: GoogleFonts.poppins(fontSize: 13, color: Colors.black87),
                  ),
                  const SizedBox(height: 10),
                ],
                if (tender.lots.isNotEmpty) ...[
                  Text(
                    'Lots:',
                    style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 6),
                  Column(
                    children: tender.lots.map((lot) {
                      return Container(
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.red.shade100),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(lot.lotName, style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
                            if (lot.sintelId.isNotEmpty) Text('Sintel ID: ${lot.sintelId}'),
                            if (lot.lotId.isNotEmpty) Text('CIG: ${lot.lotId}'),
                            if (lot.status.isNotEmpty) Text('Status: ${lot.status}'),
                            if (lot.procedureType.isNotEmpty) Text('Procedure Type: ${lot.procedureType}'),
                            if (lot.categories.isNotEmpty) Text('Categories: ${lot.categories}'),
                            if (lot.economicValue.isNotEmpty) Text('Value: ${lot.economicValue}'),
                            if (lot.startDate.isNotEmpty && lot.endDate.isNotEmpty)
                              Text('Dates: ${lot.startDate} → ${lot.endDate}'),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ]
              ],
            ),
          ),
        ],
      ),
    );
  }
}