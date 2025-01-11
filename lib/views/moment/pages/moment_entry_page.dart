import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:myapp/models/moment.dart';
import 'package:myapp/core/resources/colors.dart';
import 'package:myapp/core/resources/dimensions.dart';

import '../../common/pages/location_input_page.dart';
import '../../common/widgets/input_image.dart';
import '../bloc/moment_bloc.dart';

class MomentEntryPage extends StatefulWidget {
  static const routeName = '/moment/entry';
  const MomentEntryPage({
    super.key,
    this.momentId,
  });

  final String? momentId;

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
  final _ctrlLocation = TextEditingController();
  final _ctrlCaption = TextEditingController();

  Moment? _updatedMoment;

  @override
  void initState() {
    super.initState();
    // Periksa apakah operasi update moment
    if (widget.momentId != null) {
      context.read<MomentBloc>().add(MomentGetByIdEvent(widget.momentId!));
    }
  }

  void _initExistingData(Moment moment) {
    _updatedMoment = moment;
    _ctrlMomentDate.text = _dateFormat.format(moment.momentDate);
    _ctrlLocation.text = moment.location;
    _ctrlCaption.text = moment.caption;
  }

  @override
  void dispose() {
    _ctrlMomentDate.dispose();
    _ctrlCaption.dispose();
    _ctrlLocation.dispose();
    super.dispose();
  }

  void _saveMoment() {
    // Validasi bila input pengguna sudah sesuai
    if (_formKey.currentState!.validate()) {
      // Simpan input pengguna ke object _momentState
      _formKey.currentState!.save();
      // Menyimpan object moment ke list _moments
      if (widget.momentId != null && _updatedMoment != null) {
        context.read<MomentBloc>().add(
              MomentUpdateEvent(
                _updatedMoment!.copyWith(
                  location: _momentState['location'],
                  momentDate: _momentState['momentDate'],
                  caption: _momentState['caption'],
                  imageUrl: _momentState['imageUrl'],
                  latitude: _momentState['latitude'],
                  longitude: _momentState['longitude'],
                ),
              ),
            );
      } else {
        // Membuat object moment baru
        final newMoment = Moment(
          location: _momentState['location'],
          momentDate: _momentState['momentDate'],
          caption: _momentState['caption'],
          imageUrl: _momentState['imageUrl'],
          latitude: _momentState['latitude'],
          longitude: _momentState['longitude'],
        );
        context.read<MomentBloc>().add(MomentAddEvent(newMoment));
      }
      // Menutup halaman create moment
      Navigator.of(context).pop();
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
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () {
            context.read<MomentBloc>().add(MomentNavigateBackEvent());
          },
        ),
        title: Text('${widget.momentId != null ? 'Update' : 'Create'} Moment'),
        centerTitle: true,
      ),
      body: BlocListener<MomentBloc, MomentState>(
        listener: (context, state) {
          if (state is MomentGetByIdSuccessActionState) {
            _initExistingData(state.moment);
          }
        },
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: largeSize),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  InputImage(
                    key: UniqueKey(),
                    onSelectImage: (imageUrl) {
                      _momentState['imageUrl'] = imageUrl;
                    },
                    imageUrl: _momentState['imageUrl'],
                  ),
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
                  const Text('Location'),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
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
                      ),
                      const SizedBox(width: mediumSize),
                      IconButton(
                        icon: const Icon(Icons.location_searching),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => LocationInputPage(
                                onLocationSelected:
                                    (location, latitude, longitude) {
                                  _momentState['location'] = location;
                                  _momentState['latitude'] = latitude;
                                  _momentState['longitude'] = longitude;
                                  _ctrlCaption.text = location;
                                },
                              ),
                            ),
                          );
                        },
                      ),
                    ],
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
                    child: Text(widget.momentId != null ? 'Update' : 'Save'),
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
      ),
    );
  }
}
