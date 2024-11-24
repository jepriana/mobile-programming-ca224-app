import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:myapp/models/moment.dart';
import 'package:myapp/resources/colors.dart';
import 'package:myapp/resources/dimensions.dart';
import 'package:nanoid2/nanoid2.dart';

class MomentEntryPage extends StatefulWidget {
  const MomentEntryPage({
    super.key,
    required this.onSave,
    this.updateMoment,
  });
  final Function(Moment) onSave;
  final Moment? updateMoment;

  @override
  State<MomentEntryPage> createState() => _MomentEntryPageState();
}

class _MomentEntryPageState extends State<MomentEntryPage> {
  final _formKey = GlobalKey<FormState>();
  // Object map data
  final Map<String, dynamic> _momentState = {};
  // Definisi date format
  final _dateFormat = DateFormat('yyyy-MM-dd');
  // Definisi controller untuk form input
  final _ctrlMomentDate = TextEditingController();
  final _ctrlCreator = TextEditingController();
  final _ctrlLocation = TextEditingController();
  final _ctrlCaption = TextEditingController();
  final _ctrlImageUrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Periksa apakah operasi update moment
    if (widget.updateMoment != null) {
      _ctrlMomentDate.text =
          _dateFormat.format(widget.updateMoment!.momentDate);
      _ctrlCreator.text = widget.updateMoment!.creator;
      _ctrlLocation.text = widget.updateMoment!.location;
      _ctrlCaption.text = widget.updateMoment!.caption;
      _ctrlImageUrl.text = widget.updateMoment!.imageUrl;
    }
  }

  @override
  void dispose() {
    _ctrlMomentDate.dispose();
    _ctrlCaption.dispose();
    _ctrlCreator.dispose();
    _ctrlImageUrl.dispose();
    _ctrlLocation.dispose();
    super.dispose();
  }

  void _saveMoment() {
    // Validasi bila input pengguna sudah sesuai
    if (_formKey.currentState!.validate()) {
      // Simpan input pengguna ke object _momentState
      _formKey.currentState!.save();
      // Membuat object moment baru
      final newMoment = Moment(
        id: widget.updateMoment?.id ?? nanoid(),
        creator: _momentState['creator'],
        location: _momentState['location'],
        momentDate: _momentState['momentDate'],
        caption: _momentState['caption'],
        imageUrl: _momentState['imageUrl'],
        likesCount: widget.updateMoment?.likesCount ?? 0,
        commentsCount: widget.updateMoment?.commentsCount ?? 0,
        bookmarksCount: widget.updateMoment?.bookmarksCount ?? 0,
      );
      // Simpan moment baru ke list moment
      widget.onSave(newMoment);
      // Menutup moment entry
      Navigator.pop(context);
    }
  }

  void _pickDate(DateTime? currentDate) async {
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: currentDate ?? DateTime.now(),
      firstDate: DateTime(0000),
      lastDate: DateTime(9999),
    );
    if (selectedDate != null) {
      _ctrlMomentDate.text = _dateFormat.format(selectedDate);
      _momentState['momentDate'] = selectedDate;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Text('${widget.updateMoment != null ? 'Update' : 'Create'} Moment'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: largeSize),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text('Moment Date'),
                TextFormField(
                  controller: _ctrlMomentDate,
                  keyboardType: TextInputType.datetime,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(
                    hintText: 'Enter moment date',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.zero,
                    ),
                  ),
                  validator: (value) {
                    if (value == null ||
                        value.isEmpty ||
                        DateTime.tryParse(value) == null) {
                      return 'Please enter a moment date in format yyyy-MM-dd';
                    }
                    return null;
                  },
                  onSaved: (newValue) {
                    // Bila moment date tidak kosong maka simpan ke object map
                    if (newValue != null) {
                      _momentState['momentDate'] = DateTime.parse(newValue);
                    }
                  },
                  onTap: () =>
                      _pickDate(DateTime.tryParse(_ctrlMomentDate.text)),
                ),
                const Text('Creator Name'),
                TextFormField(
                  controller: _ctrlCreator,
                  keyboardType: TextInputType.name,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(
                    hintText: 'Enter moment creator',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.zero,
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter creator name';
                    }
                    return null;
                  },
                  onSaved: (newValue) {
                    // Bila nama kreator tidak kosong maka simpan ke object map
                    if (newValue != null) {
                      _momentState['creator'] = newValue.toString();
                    }
                  },
                ),
                const Text('Location'),
                TextFormField(
                  controller: _ctrlLocation,
                  keyboardType: TextInputType.streetAddress,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(
                    hintText: 'Enter moment location',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.zero,
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter moment location';
                    }
                    return null;
                  },
                  onSaved: (newValue) {
                    // Bila nama kreator tidak kosong maka simpan ke object map
                    if (newValue != null) {
                      _momentState['location'] = newValue.toString();
                    }
                  },
                ),
                const Text('Caption'),
                TextFormField(
                  controller: _ctrlCaption,
                  keyboardType: TextInputType.multiline,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(
                    hintText: 'Enter moment caption',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.zero,
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter moment caption';
                    }
                    return null;
                  },
                  onSaved: (newValue) {
                    // Bila nama kreator tidak kosong maka simpan ke object map
                    if (newValue != null) {
                      _momentState['caption'] = newValue.toString();
                    }
                  },
                ),
                const Text('Image URL'),
                TextFormField(
                  controller: _ctrlImageUrl,
                  keyboardType: TextInputType.url,
                  textInputAction: TextInputAction.send,
                  decoration: const InputDecoration(
                    hintText: 'Enter moment image URL',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.zero,
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter moment image URL';
                    }
                    return null;
                  },
                  onSaved: (newValue) {
                    // Bila nama kreator tidak kosong maka simpan ke object map
                    if (newValue != null) {
                      _momentState['imageUrl'] = newValue.toString();
                    }
                  },
                  onFieldSubmitted: (value) {
                    _saveMoment();
                  },
                ),
                const SizedBox(height: largeSize),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(50),
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.zero,
                    ),
                    backgroundColor: primaryColor,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: _saveMoment,
                  child: Text(widget.updateMoment != null ? 'Update' : 'Save'),
                ),
                const SizedBox(height: mediumSize),
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size.fromHeight(50),
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.zero,
                    ),
                    side: const BorderSide(color: primaryColor),
                  ),
                  onPressed: () {
                    // Menutup moment entry
                    Navigator.pop(context);
                  },
                  child: const Text('Cancel'),
                ),
                const SizedBox(height: largeSize),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
