import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/ProfilCubit.dart';
import '../model/ProfileModel.dart';
import '../states/ProfileState.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<SettingsPage> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _usernameController;
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;

  UserProfileModel? _initialUser;

  @override
  void initState() {
    super.initState();
    context.read<ProfileCubit>().fetchProfile(); // جلب بيانات المستخدم عند فتح الصفحة
    _usernameController = TextEditingController();
    _firstNameController = TextEditingController();
    _lastNameController = TextEditingController();
  }


  @override
  void dispose() {
    _usernameController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    super.dispose();
  }

  void _submitUpdate() {
    if (!_formKey.currentState!.validate()) return;

    final updatedUser = UserProfileModel(
      id: _initialUser!.id,
      username: _usernameController.text.trim(),
      firstName: _firstNameController.text.trim(),
      lastName: _lastNameController.text.trim(),
    );

    context.read<ProfileCubit>().updateUserProfile(updatedUser);
  }

  void _resetForm() {
    if (_initialUser != null) {
      _usernameController.text = _initialUser!.username;
      _firstNameController.text = _initialUser!.firstName;
      _lastNameController.text = _initialUser!.lastName;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("تم إلغاء التغييرات")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('تعديل الملف الشخصي'),
          centerTitle: true,
          elevation: 0,
          backgroundColor: Colors.white,
          foregroundColor: Colors.black87,
        ),
        body: BlocConsumer<ProfileCubit, ProfileState>(
          listener: (context, state) {
            if (state is ProfileUpdated) {
              setState(() => _initialUser = state.user);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message), backgroundColor: Colors.green),
              );
            } else if (state is ProfileFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message), backgroundColor: Colors.red),
              );
            } else if (state is ProfileSuccess && _initialUser == null) {
              setState(() {
                _initialUser = state.user;
                _usernameController.text = _initialUser!.username;
                _firstNameController.text = _initialUser!.firstName;
                _lastNameController.text = _initialUser!.lastName;
              });
            }
          },
          builder: (context, state) {
            if (_initialUser == null) {
              return const Center(child: CircularProgressIndicator());
            }

            final isLoading = state is ProfileLoading;

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    // صورة رمزية بالأحرف الأولى
                    Center(
                      child: CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.blue[100],
                        child: Text(
                          _firstNameController.text.isNotEmpty
                              ? _firstNameController.text[0].toUpperCase()
                              : 'U',
                          style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),

                    _buildSectionTitle('معلومات الحساب'),
                    const SizedBox(height: 16),

                    _buildFormField(
                      label: 'اسم المستخدم',
                      controller: _usernameController,
                      icon: Icons.account_circle,
                      validator: (value) {
                        if (value == null || value.isEmpty) return 'مطلوب';
                        if (value.contains(' ')) return 'لا يمكن أن يحتوي على مسافات';
                        return null;
                      },
                    ),

                    const SizedBox(height: 24),

                    _buildSectionTitle('المعلومات الشخصية'),
                    const SizedBox(height: 16),

                    _buildFormField(
                      label: 'الاسم الأول',
                      controller: _firstNameController,
                      icon: Icons.person,
                      validator: (v) => v == null || v.isEmpty ? 'مطلوب' : null,
                    ),

                    const SizedBox(height: 16),

                    _buildFormField(
                      label: 'اسم العائلة',
                      controller: _lastNameController,
                      icon: Icons.person,
                      validator: (v) => v == null || v.isEmpty ? 'مطلوب' : null,
                    ),

                    const SizedBox(height: 32),

                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: isLoading ? null : _submitUpdate,
                        child: isLoading
                            ? const CircularProgressIndicator(color: Colors.white)
                            : const Text('حفظ التغييرات'),
                      ),
                    ),

                    const SizedBox(height: 16),

                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: OutlinedButton(
                        onPressed: isLoading ? null : _resetForm,
                        child: const Text('إلغاء التغييرات'),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Align(
      alignment: Alignment.centerRight,
      child: Text(
        title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildFormField({
    required String label,
    required TextEditingController controller,
    required IconData icon,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: const OutlineInputBorder(),
      ),
    );
  }
}
