import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:tender_ui/services/filter_service.dart';

const Color jnjRed = Color(0xFFD71920);

class LombardiaFilterPage extends StatefulWidget {
  @override
  _LombardiaFilterPageState createState() => _LombardiaFilterPageState();
}

class _LombardiaFilterPageState extends State<LombardiaFilterPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController cigCodeController = TextEditingController();
  final TextEditingController sintelIdController = TextEditingController();
  final TextEditingController auctionNameController = TextEditingController();
  final TextEditingController categoryController = TextEditingController();
  final TextEditingController auctionCodeController = TextEditingController();

  List<String> selectedAuctionTypes = [];
  List<String> selectedAuctionStatuses = [];
  List<String> selectedBidTypes = [];

  DateTime? dateFrom;
  DateTime? dateTo;

final Map<String, String> auctionTypeOptions = {
  "auction.rfq.sealed": "Cottimo fiduciario (ad invito diretto)",
  "auction.multiplelot": "Multilotto",
  "auction.restricted": "Procedura Ristretta",
  "auction.reserved.negotiated": "Procedura negoziata senza pubblicazione di un bando",
  "auction.reserved.rfp": "Procedura negoziata con la pubblicazione di un bando",
  "auction.open.negotiated": "Procedura Aperta",
  "auction.rdo": "RdO (Richiesta di Offerta)",
  "auction.exrdo.rfq": "Affidamento diretto",
  "auction.exrdo.estimate.request": "Affidamento diretto previa richiesta di preventivi",
  "auction.exrdo.interest.manifest": "Manifestazione di interesse",
  "auction.exrdo.market.survey": "Indagine di mercato",
  "auction.sda.bi": "Sistema Dinamico di Acquisizione - Bando istitutivo",
  "auction.sda.bs": "Sistema Dinamico di Acquisizione - Bando semplificato",
  "auction.sda.as": "Sistema Dinamico di Acquisizione - Appalto specifico",
};


  final List<String> auctionStatusOptions = [
    "Open", "PublishedAcceptingRequest", "PublishedEvaluatingRequest", "JudgementBoardAppointment",
    "OfflineBid", "Evaluating", "PrepareLaunchElectronicAuction", "ElectronicAuctionPlanned",
    "ElectronicAuctionPublished", "ElectronicAuctionOpened", "ElectronicAuctionWaitingTimeLag",
    "ElectronicAuctionConfirmOffer", "ElectronicAuctionClosed", "CommitteeMinutesCreation",
    "TemporaryAdjudicated", "DefinitiveAdjudicated", "Suspended", "Adjudicated", "Adjudicating",
    "Concluded", "Killed", "Terminated", "Closed"
  ];

  final Map<String, String> bidTypeOptions = {
    "2": "Procedura per forniture/servizi",
    "3": "Procedura per farmaci",
    "4": "Procedura per dispositivi medici",
    "5": "Procedura per forniture/servizi sanitari",
    "6": "Procedura per forniture/servizi ferroviari",
    "7": "Procedura per lavori",
    "8": "Procedura per incarichi a liberi professionisti",
    "9": "Procedure per concessioni",
    "10": "Procedure per concorsi pubblici di progettazione",
    "11": "Procedure per servizi sociali e altri servizi",
  };

  Future<void> _selectDate(BuildContext context, bool isFrom) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      setState(() {
        if (isFrom) {
          dateFrom = picked;
        } else {
          dateTo = picked;
        }
      });
    }
  }

  Widget _buildMultiSelect(String label, List<String> selectedValues, List<String> options) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontWeight: FontWeight.bold)),
        Wrap(
          spacing: 8.0,
          children: options.map((option) {
            final isSelected = selectedValues.contains(option);
            return FilterChip(
              label: Text(option),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  if (selected) {
                    selectedValues.add(option);
                  } else {
                    selectedValues.remove(option);
                  }
                });
              },
            );
          }).toList(),
        ),
        SizedBox(height: 10),
      ],
    );
  }

Widget _buildAuctionTypeMultiSelect() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text('Auction Type', style: TextStyle(fontWeight: FontWeight.bold)),
      Wrap(
        spacing: 8.0,
        children: auctionTypeOptions.entries.map((entry) {
          final isSelected = selectedAuctionTypes.contains(entry.key);
          return FilterChip(
            label: Text(entry.value),
            selected: isSelected,
            onSelected: (selected) {
              setState(() {
                if (selected) {
                  selectedAuctionTypes.add(entry.key);
                } else {
                  selectedAuctionTypes.remove(entry.key);
                }
              });
            },
          );
        }).toList(),
      ),
      SizedBox(height: 10),
    ],
  );
}

void _showLoadingDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(),
            const SizedBox(width: 20),
            Flexible(
              child: Text(
                'Applying filters and scraping the result...',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

  Widget _buildBidTypeMultiSelect() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Bid Type', style: TextStyle(fontWeight: FontWeight.bold)),
        Wrap(
          spacing: 8.0,
          children: bidTypeOptions.entries.map((entry) {
            final isSelected = selectedBidTypes.contains(entry.key);
            return FilterChip(
              label: Text(entry.value),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  if (selected) {
                    selectedBidTypes.add(entry.key);
                  } else {
                    selectedBidTypes.remove(entry.key);
                  }
                });
              },
            );
          }).toList(),
        ),
        SizedBox(height: 10),
      ],
    );
  }

@override
Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: Colors.transparent,
    appBar: AppBar(
      title: const Text('Lombardia Tender Filters'),
      backgroundColor: jnjRed,
    ),
    body: SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Configure filters for Lombardia tenders',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: jnjRed,
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 24),

          Card(
            elevation: 5,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: cigCodeController,
                      decoration: const InputDecoration(
                        labelText: 'CIG Code',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: sintelIdController,
                      decoration: const InputDecoration(
                        labelText: 'Sintel ID',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: auctionNameController,
                      decoration: const InputDecoration(
                        labelText: 'Auction Name',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: categoryController,
                      decoration: const InputDecoration(
                        labelText: 'Category',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: auctionCodeController,
                      decoration: const InputDecoration(
                        labelText: 'Auction Code',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Multiselects
                    _buildAuctionTypeMultiSelect(),
                    const SizedBox(height: 16),
                    _buildMultiSelect('Auction Status', selectedAuctionStatuses, auctionStatusOptions),
                    const SizedBox(height: 16),
                    _buildBidTypeMultiSelect(),
                    const SizedBox(height: 24),

                    // Date pickers
                    Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      child: Column(
                        children: [
                          ListTile(
                            title: Text(
                              'Date From: ${dateFrom != null ? dateFrom!.toLocal().toString().split(' ')[0] : 'Not selected'}',
                            ),
                            trailing: const Icon(Icons.calendar_today),
                            onTap: () => _selectDate(context, true),
                          ),
                          ListTile(
                            title: Text(
                              'Date To: ${dateTo != null ? dateTo!.toLocal().toString().split(' ')[0] : 'Not selected'}',
                            ),
                            trailing: const Icon(Icons.calendar_today),
                            onTap: () => _selectDate(context, false),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.filter_alt),
                        label: const Text('Apply Filters'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: jnjRed,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () async {
                          _showLoadingDialog(context); // Show spinner
                          try {
                            final filterService = FilterService();
                            await filterService.submitLombardiaFilters(
                              context: context,
                              cigCode: cigCodeController.text,
                              sintelId: sintelIdController.text,
                              auctionName: auctionNameController.text,
                              category: categoryController.text,
                              auctionCode: auctionCodeController.text,
                              selectedAuctionTypes: selectedAuctionTypes,
                              selectedAuctionStatuses: selectedAuctionStatuses,
                              selectedBidTypes: selectedBidTypes,
                              dateFrom: dateFrom,
                              dateTo: dateTo,
                            );
                          } finally {
                            Navigator.of(context, rootNavigator: true).pop(); // Close spinner
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}}