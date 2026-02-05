import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final supabase = Supabase.instance.client;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://yjbjnhckgiehdwahzkvq.supabase.co',
    anonKey: 'sb_publishable_bIM35wBG4utlUA3xSRU9XQ_OROeEe0q',
  );

  runApp(const DoctorApp());
}

// -------------------- GLOBAL DATA --------------------
List<Map<String, dynamic>> doctors = [
  {
    "name": "Dr. Sneha Nu",
    "specialty": "Cardiologist",
    "imageUrl":
        "https://images.unsplash.com/photo-1550831107-1553da8c8464?auto=format&fit=crop&w=400&q=80",
  },
  {
    "name": "Dr. Vargo Ho",
    "specialty": "Neurologist",
    "imageUrl":
        "https://images.unsplash.com/photo-1527613426441-4da17471b66d?auto=format&fit=crop&w=400&q=80",
  },
  {
    "name": "Dr. John Smith",
    "specialty": "Dentist",
    "imageUrl":
        "https://images.unsplash.com/photo-1537368910025-700350fe46c7?auto=format&fit=crop&w=400&q=80",
  },
  {
    "name": "Dr. Emily Rose",
    "specialty": "Eye Specialist",
    "imageUrl":
        "https://images.pexels.com/photos/7578806/pexels-photo-7578806.jpeg",
  },
];

// -------------------- APP ROOT --------------------
class DoctorApp extends StatelessWidget {
  const DoctorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'HelloCare',
      themeMode: ThemeMode.light,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        scaffoldBackgroundColor: const Color(0xFFF7F9FC),
        colorScheme: const ColorScheme.light(
          primary: Color(0xFF4F46E5),
          secondary: Color(0xFF0EA5E9),
          surface: Colors.white,
          background: Color(0xFFF7F9FC),
          onPrimary: Colors.white,
          onSurface: Colors.black87,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          iconTheme: IconThemeData(color: Colors.black87),
          titleTextStyle: TextStyle(
            color: Colors.black87,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        cardTheme: CardThemeData(
          color: Colors.white,
          elevation: 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        navigationBarTheme: NavigationBarThemeData(
          backgroundColor: Colors.white,
          indicatorColor: const Color(0xFF4F46E5).withOpacity(0.12),
          labelTextStyle: MaterialStateProperty.all(
            const TextStyle(color: Colors.black87, fontSize: 12),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: Color(0xFF4F46E5), width: 1.5),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF4F46E5),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
        ),
      ),
      home: supabase.auth.currentUser == null
          ? const LoginPage()
          : const SplashScreen(),
    );
  }
}

// -------------------- LOGIN PAGE --------------------
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool isLoading = false;

  Future<void> login() async {
    setState(() => isLoading = true);
    try {
      await supabase.auth.signInWithPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const SplashScreen()),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Login failed: $e")));
    }
    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Login")),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const SizedBox(height: 30),
              const Icon(
                Icons.local_hospital,
                size: 80,
                color: Color(0xFF4F46E5),
              ),
              const SizedBox(height: 20),
              const Text(
                "Welcome Back",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                "Login to continue",
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 30),
              TextField(
                controller: emailController,
                decoration: const InputDecoration(labelText: "Email"),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: const InputDecoration(labelText: "Password"),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: isLoading ? null : login,
                  child: isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text("Login"),
                ),
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const SignupPage()),
                  );
                },
                child: const Text("Create account"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// -------------------- SIGNUP PAGE --------------------
class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool isLoading = false;

  Future<void> signup() async {
    setState(() => isLoading = true);
    try {
      await supabase.auth.signUp(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Account created! Please login.")),
      );
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Signup failed: $e")));
    }
    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Sign Up")),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const SizedBox(height: 30),
              const Text(
                "Create Account",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                "Sign up to get started",
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 30),
              TextField(
                controller: emailController,
                decoration: const InputDecoration(labelText: "Email"),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: const InputDecoration(labelText: "Password"),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: isLoading ? null : signup,
                  child: isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text("Create Account"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// -------------------- SPLASH SCREEN --------------------
class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFEEF2FF), Color(0xFFF7F9FC)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // App Logo / Doctor Image
                ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: Image.network(
                    "https://images.pexels.com/photos/14996490/pexels-photo-14996490.jpeg",
                    height: 180,
                    width: 180,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(
                        Icons.local_hospital,
                        size: 120,
                        color: Color(0xFF4F46E5),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 30),

                const Text(
                  "HelloCare",
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),

                const SizedBox(height: 10),

                const Text(
                  "Book doctor appointments easily",
                  style: TextStyle(color: Colors.black54, fontSize: 16),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 40),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: const Text(
                      "Get Started",
                      style: TextStyle(fontSize: 16),
                    ),
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (_) => const HomeScreen()),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// -------------------- HOME SCREEN --------------------
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currentIndex = 0;

  final List<Widget> pages = const [
    HomePage(),
    AppointmentPage(),
    MessagePage(),
    SettingsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[currentIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: currentIndex,
        onDestinationSelected: (index) {
          setState(() => currentIndex = index);
        },
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home), label: "Home"),
          NavigationDestination(
            icon: Icon(Icons.calendar_today),
            label: "Appointments",
          ),
          NavigationDestination(icon: Icon(Icons.message), label: "Messages"),
          NavigationDestination(icon: Icon(Icons.settings), label: "Settings"),
        ],
      ),
    );
  }
}

// -------------------- HOME PAGE --------------------
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const SizedBox(height: 20),
              _buildSearchBar(),
              const SizedBox(height: 20),
              _buildSectionTitle(
                "Categories",
                context,
                const AllCategoriesPage(),
              ),
              const SizedBox(height: 12),
              _buildCategoriesRow(),
              const SizedBox(height: 24),
              _buildSectionTitle(
                "Top Doctors",
                context,
                const AllDoctorsPage(),
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 250,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: doctors.length,
                  itemBuilder: (context, index) {
                    final doc = doctors[index];
                    return DoctorCard(
                      name: doc['name'],
                      specialty: doc['specialty'],
                      imageUrl: doc['imageUrl'],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: const [
        CircleAvatar(
          radius: 24,
          backgroundImage: NetworkImage(
            "https://images.unsplash.com/photo-1607746882042-944635dfe10e?auto=format&fit=crop&w=400&q=80",
          ),
        ),
        SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Hello,", style: TextStyle(color: Colors.grey)),
            Text(
              "Robert Smi",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ],
        ),
        Spacer(),
        Icon(Icons.notifications_none, size: 28),
      ],
    );
  }

  Widget _buildSearchBar() {
    return TextField(
      decoration: InputDecoration(
        hintText: "Search doctors, specialties...",
        prefixIcon: const Icon(Icons.search),
      ),
    );
  }

  Widget _buildSectionTitle(String title, BuildContext context, Widget page) {
    return Row(
      children: [
        Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        const Spacer(),
        TextButton(
          child: const Text(
            "View all",
            style: TextStyle(color: Color(0xFF4F46E5)),
          ),
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (_) => page));
          },
        ),
      ],
    );
  }

  Widget _buildCategoriesRow() {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CategoryCard(icon: Icons.psychology, label: "Neurologist"),
        CategoryCard(icon: Icons.medical_services, label: "Dentist"),
        CategoryCard(icon: Icons.favorite, label: "Cardiologist"),
        CategoryCard(icon: Icons.visibility, label: "Eye"),
      ],
    );
  }
}

// -------------------- CATEGORY CARD --------------------
class CategoryCard extends StatelessWidget {
  final IconData icon;
  final String label;

  const CategoryCard({super.key, required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: const Color(0xFFEFF1FF),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Icon(icon, color: const Color(0xFF4F46E5), size: 28),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: Colors.black87),
        ),
      ],
    );
  }
}

// -------------------- DOCTOR CARD --------------------
class DoctorCard extends StatelessWidget {
  final String name;
  final String specialty;
  final String imageUrl;

  const DoctorCard({
    super.key,
    required this.name,
    required this.specialty,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 180,
      margin: const EdgeInsets.only(right: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            CircleAvatar(radius: 42, backgroundImage: NetworkImage(imageUrl)),
            const SizedBox(height: 10),
            Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text(specialty, style: const TextStyle(color: Colors.black54)),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                child: const Text("Book"),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => BookAppointmentPage(
                        doctorName: name,
                        specialty: specialty,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// -------------------- BOOK APPOINTMENT PAGE --------------------
class BookAppointmentPage extends StatefulWidget {
  final String doctorName;
  final String specialty;

  const BookAppointmentPage({
    super.key,
    required this.doctorName,
    required this.specialty,
  });

  @override
  State<BookAppointmentPage> createState() => _BookAppointmentPageState();
}

class _BookAppointmentPageState extends State<BookAppointmentPage> {
  String selectedReason = "Follow Up";
  String selectedType = "Online";

  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = const TimeOfDay(hour: 10, minute: 30);

  Future<void> pickDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null) setState(() => selectedDate = picked);
  }

  Future<void> pickTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );
    if (picked != null) setState(() => selectedTime = picked);
  }

  Future<void> saveAppointment() async {
    final user = supabase.auth.currentUser;

    if (user == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Please login first")));
      return;
    }

    String day = selectedDate.day.toString().padLeft(2, '0');
    String month = selectedDate.month.toString().padLeft(2, '0');
    String formattedTime = selectedTime.format(context);

    try {
      await supabase.from('appointments').insert({
        'doctor_name': widget.doctorName,
        'specialty': widget.specialty,
        'date': "$day/$month/${selectedDate.year}",
        'time': formattedTime,
        'reason': selectedReason,
        'type': selectedType,
        'user_id': user.id,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Appointment booked successfully!")),
      );
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error saving appointment: $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    String day = selectedDate.day.toString().padLeft(2, '0');
    String month = selectedDate.month.toString().padLeft(2, '0');
    String formattedTime = selectedTime.format(context);

    return Scaffold(
      appBar: AppBar(title: const Text("Book Appointment")),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _sectionTitle("Doctor"),
              Card(
                child: ListTile(
                  leading: const Icon(Icons.person),
                  title: Text(widget.doctorName),
                  subtitle: Text(widget.specialty),
                ),
              ),
              const SizedBox(height: 20),

              _sectionTitle("Date & Time"),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: pickDate,
                    child: DateBox(title: "Day", value: day),
                  ),
                  GestureDetector(
                    onTap: pickDate,
                    child: DateBox(
                      title: "Month",
                      value: month,
                      highlighted: true,
                    ),
                  ),
                  GestureDetector(
                    onTap: pickTime,
                    child: DateBox(title: "Time", value: formattedTime),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              _sectionTitle("Reason"),
              _buildDropdown(),
              const SizedBox(height: 20),

              _sectionTitle("Appointment Type"),
              Row(
                children: [
                  Expanded(
                    child: ChoiceChip(
                      label: const Text("Online"),
                      selected: selectedType == "Online",
                      onSelected: (_) =>
                          setState(() => selectedType = "Online"),
                      selectedColor: const Color(0xFF4F46E5),
                      labelStyle: TextStyle(
                        color: selectedType == "Online"
                            ? Colors.white
                            : Colors.black87,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ChoiceChip(
                      label: const Text("In-Person"),
                      selected: selectedType == "In-Person",
                      onSelected: (_) =>
                          setState(() => selectedType = "In-Person"),
                      selectedColor: const Color(0xFF4F46E5),
                      labelStyle: TextStyle(
                        color: selectedType == "In-Person"
                            ? Colors.white
                            : Colors.black87,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              const Divider(),
              Row(children: const [Text("Doctor Fee"), Spacer(), Text("\$18")]),
              const SizedBox(height: 6),
              Row(
                children: const [Text("Platform Fee"), Spacer(), Text("\$2")],
              ),
              const Divider(height: 30),
              Row(
                children: const [
                  Text("Total", style: TextStyle(fontWeight: FontWeight.bold)),
                  Spacer(),
                  Text("\$20", style: TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),

              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  child: const Text("Confirm Booking"),
                  onPressed: saveAppointment,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _sectionTitle(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
      ),
    );
  }

  Widget _buildDropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: DropdownButton<String>(
        value: selectedReason,
        isExpanded: true,
        underline: const SizedBox(),
        items: const [
          DropdownMenuItem(value: "Follow Up", child: Text("Follow Up")),
          DropdownMenuItem(value: "Consultation", child: Text("Consultation")),
          DropdownMenuItem(value: "Checkup", child: Text("Checkup")),
        ],
        onChanged: (value) {
          setState(() => selectedReason = value!);
        },
      ),
    );
  }
}

// -------------------- DATE BOX --------------------
class DateBox extends StatelessWidget {
  final String title;
  final String value;
  final bool highlighted;

  const DateBox({
    super.key,
    required this.title,
    required this.value,
    this.highlighted = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 90,
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: highlighted ? const Color(0xFF4F46E5) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: highlighted ? const Color(0xFF4F46E5) : Colors.grey.shade300,
        ),
      ),
      child: Column(
        children: [
          Text(
            title,
            style: TextStyle(color: highlighted ? Colors.white : Colors.grey),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: TextStyle(
              color: highlighted ? Colors.white : Colors.black87,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
        ],
      ),
    );
  }
}

// -------------------- APPOINTMENT PAGE --------------------
class AppointmentPage extends StatefulWidget {
  const AppointmentPage({super.key});

  @override
  State<AppointmentPage> createState() => _AppointmentPageState();
}

class _AppointmentPageState extends State<AppointmentPage> {
  List<Map<String, dynamic>> appointments = [];

  @override
  void initState() {
    super.initState();
    fetchAppointments();
  }

  Future<void> fetchAppointments() async {
    final user = supabase.auth.currentUser;
    if (user == null) return;

    final data = await supabase
        .from('appointments')
        .select()
        .eq('user_id', user.id)
        .order('date', ascending: true);

    setState(() {
      appointments = List<Map<String, dynamic>>.from(data);
    });
  }

  Future<void> deleteAppointment(String id) async {
    await supabase.from('appointments').delete().eq('id', id);
    fetchAppointments();
  }

  void editAppointment(Map<String, dynamic> item) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => EditAppointmentPage(appointment: item)),
    ).then((_) => fetchAppointments());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("My Appointments")),
      body: appointments.isEmpty
          ? const Center(child: Text("No appointments yet"))
          : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: appointments.length,
              itemBuilder: (context, index) {
                final item = appointments[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    leading: const Icon(Icons.event, color: Color(0xFF4F46E5)),
                    title: Text(item['doctor_name']),
                    subtitle: Text(
                      "${item['specialty']} • ${item['date']} • ${item['time']}\n${item['reason']} • ${item['type']}",
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(
                            Icons.edit,
                            color: Colors.blueAccent,
                          ),
                          onPressed: () => editAppointment(item),
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.delete,
                            color: Colors.redAccent,
                          ),
                          onPressed: () => deleteAppointment(item['id']),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}

// -------------------- EDIT APPOINTMENT PAGE --------------------
class EditAppointmentPage extends StatefulWidget {
  final Map<String, dynamic> appointment;

  const EditAppointmentPage({super.key, required this.appointment});

  @override
  State<EditAppointmentPage> createState() => _EditAppointmentPageState();
}

class _EditAppointmentPageState extends State<EditAppointmentPage> {
  late DateTime selectedDate;
  late TimeOfDay selectedTime;
  late String selectedReason;
  late String selectedType;

  @override
  void initState() {
    super.initState();

    // Parse date
    List<String> parts = widget.appointment['date'].split('/');
    selectedDate = DateTime(
      int.parse(parts[2]),
      int.parse(parts[1]),
      int.parse(parts[0]),
    );

    // Parse time
    final timeParts = widget.appointment['time'].split(' ');
    final hourMin = timeParts[0].split(':');
    selectedTime = TimeOfDay(
      hour: int.parse(hourMin[0]),
      minute: int.parse(hourMin[1]),
    );

    selectedReason = widget.appointment['reason'];
    selectedType = widget.appointment['type'];
  }

  Future<void> pickDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null) setState(() => selectedDate = picked);
  }

  Future<void> pickTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );
    if (picked != null) setState(() => selectedTime = picked);
  }

  Future<void> updateAppointment() async {
    String day = selectedDate.day.toString().padLeft(2, '0');
    String month = selectedDate.month.toString().padLeft(2, '0');
    String timeFormatted = selectedTime.format(context);

    try {
      await supabase
          .from('appointments')
          .update({
            'date': "$day/$month/${selectedDate.year}",
            'time': timeFormatted,
            'reason': selectedReason,
            'type': selectedType,
          })
          .eq('id', widget.appointment['id']);

      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Appointment updated successfully!")),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error updating appointment: $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    String day = selectedDate.day.toString().padLeft(2, '0');
    String month = selectedDate.month.toString().padLeft(2, '0');
    String timeFormatted = selectedTime.format(context);

    return Scaffold(
      appBar: AppBar(title: const Text("Edit Appointment")),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Select Date & Time",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 12),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: pickDate,
                    child: DateBox(title: "Day", value: day),
                  ),
                  GestureDetector(
                    onTap: pickDate,
                    child: DateBox(
                      title: "Month",
                      value: month,
                      highlighted: true,
                    ),
                  ),
                  GestureDetector(
                    onTap: pickTime,
                    child: DateBox(title: "Time", value: timeFormatted),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              const Text(
                "Reason To Visit",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 10),

              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: DropdownButton<String>(
                  value: selectedReason,
                  isExpanded: true,
                  underline: const SizedBox(),
                  items: const [
                    DropdownMenuItem(
                      value: "Follow Up",
                      child: Text("Follow Up"),
                    ),
                    DropdownMenuItem(
                      value: "Consultation",
                      child: Text("Consultation"),
                    ),
                    DropdownMenuItem(value: "Checkup", child: Text("Checkup")),
                  ],
                  onChanged: (value) {
                    setState(() => selectedReason = value!);
                  },
                ),
              ),

              const SizedBox(height: 16),

              const Text(
                "Appointment Type",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 10),

              Row(
                children: [
                  Expanded(
                    child: ChoiceChip(
                      label: const Text("Online"),
                      selected: selectedType == "Online",
                      selectedColor: const Color(0xFF4F46E5),
                      labelStyle: TextStyle(
                        color: selectedType == "Online"
                            ? Colors.white
                            : Colors.black87,
                      ),
                      onSelected: (_) =>
                          setState(() => selectedType = "Online"),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ChoiceChip(
                      label: const Text("In-Person"),
                      selected: selectedType == "In-Person",
                      selectedColor: const Color(0xFF4F46E5),
                      labelStyle: TextStyle(
                        color: selectedType == "In-Person"
                            ? Colors.white
                            : Colors.black87,
                      ),
                      onSelected: (_) =>
                          setState(() => selectedType = "In-Person"),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 32),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: updateAppointment,
                  child: const Text("Update Appointment"),
                ),
              ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
<<<<<<< HEAD
=======

// -------------------- ALL CATEGORIES PAGE --------------------
class AllCategoriesPage extends StatelessWidget {
  const AllCategoriesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final categories = [
      {
        "icon": Icons.psychology,
        "label": "Neurologist",
        "page": const NeurologistPage(),
      },
      {
        "icon": Icons.medical_services,
        "label": "Dentist",
        "page": const DentistPage(),
      },
      {
        "icon": Icons.favorite,
        "label": "Cardiologist",
        "page": const CardiologistPage(),
      },
      {
        "icon": Icons.visibility,
        "label": "Eye Specialist",
        "page": const EyePage(),
      },
      {
        "icon": Icons.healing,
        "label": "General Physician",
        "page": const GeneralPage(),
      },
      {
        "icon": Icons.child_care,
        "label": "Pediatrician",
        "page": const PediatricianPage(),
      },
    ];

    return Scaffold(
      appBar: AppBar(title: const Text("All Categories")),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
        ),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final cat = categories[index];
          return InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => cat["page"] as Widget),
              );
            },
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEFF1FF),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(
                    cat["icon"] as IconData,
                    color: const Color(0xFF4F46E5),
                    size: 32,
                  ),
                ),
                const SizedBox(height: 8),
                Text(cat["label"] as String, textAlign: TextAlign.center),
              ],
            ),
          );
        },
      ),
    );
  }
}

// -------------------- SPECIALTY DOCTOR LIST --------------------
class SpecialtyDoctorList extends StatelessWidget {
  final String title;
  final List<Map<String, String>> doctors;

  const SpecialtyDoctorList({
    super.key,
    required this.title,
    required this.doctors,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: doctors.length,
        itemBuilder: (context, index) {
          final doc = doctors[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              leading: const Icon(Icons.person),
              title: Text(doc["name"]!),
              subtitle: Text(doc["hospital"]!),
              trailing: ElevatedButton(
                child: const Text("Book"),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => BookAppointmentPage(
                        doctorName: doc["name"]!,
                        specialty: title,
                      ),
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}

// -------------------- SPECIALTY PAGES --------------------
class NeurologistPage extends StatelessWidget {
  const NeurologistPage({super.key});

  @override
  Widget build(BuildContext context) {
    final doctors = [
      {"name": "Dr. Amaya Silva", "hospital": "City Hospital"},
      {"name": "Dr. Nuwan Perera", "hospital": "Neuro Care Center"},
    ];
    return SpecialtyDoctorList(title: "Neurologists", doctors: doctors);
  }
}

class DentistPage extends StatelessWidget {
  const DentistPage({super.key});

  @override
  Widget build(BuildContext context) {
    final doctors = [
      {"name": "Dr. Shehani Fernando", "hospital": "Smile Dental Clinic"},
      {"name": "Dr. Ruwan Jayasekara", "hospital": "Bright Teeth Care"},
    ];
    return SpecialtyDoctorList(title: "Dentists", doctors: doctors);
  }
}

class CardiologistPage extends StatelessWidget {
  const CardiologistPage({super.key});

  @override
  Widget build(BuildContext context) {
    final doctors = [
      {"name": "Dr. Sanjaya Rathnayake", "hospital": "Heart Care Hospital"},
      {"name": "Dr. Malini Perera", "hospital": "Life Cardio Center"},
    ];
    return SpecialtyDoctorList(title: "Cardiologists", doctors: doctors);
  }
}

class EyePage extends StatelessWidget {
  const EyePage({super.key});

  @override
  Widget build(BuildContext context) {
    final doctors = [
      {"name": "Dr. Lakshmi Perera", "hospital": "Vision Care Center"},
      {"name": "Dr. Tharindu Silva", "hospital": "Eye Clinic Colombo"},
    ];
    return SpecialtyDoctorList(title: "Eye Specialists", doctors: doctors);
  }
}

class GeneralPage extends StatelessWidget {
  const GeneralPage({super.key});

  @override
  Widget build(BuildContext context) {
    final doctors = [
      {"name": "Dr. Kavindu Fernando", "hospital": "Family Care Hospital"},
      {"name": "Dr. Yasara Jayasinghe", "hospital": "Health Plus Clinic"},
    ];
    return SpecialtyDoctorList(title: "General Physicians", doctors: doctors);
  }
}

class PediatricianPage extends StatelessWidget {
  const PediatricianPage({super.key});

  @override
  Widget build(BuildContext context) {
    final doctors = [
      {"name": "Dr. Sachini Wijesinghe", "hospital": "Kids Care Hospital"},
      {"name": "Dr. Nimal Perera", "hospital": "Children’s Medical Center"},
    ];
    return SpecialtyDoctorList(title: "Pediatricians", doctors: doctors);
  }
}

// -------------------- ALL DOCTORS PAGE --------------------
class AllDoctorsPage extends StatelessWidget {
  const AllDoctorsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("All Doctors")),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: doctors.length,
        itemBuilder: (context, index) {
          final doc = doctors[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            child: ListTile(
              leading: CircleAvatar(
                backgroundImage: NetworkImage(doc['imageUrl']),
              ),
              title: Text(doc['name']),
              subtitle: Text(doc['specialty']),
              trailing: ElevatedButton(
                child: const Text("Book"),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => BookAppointmentPage(
                        doctorName: doc['name'],
                        specialty: doc['specialty'],
                      ),
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}

// -------------------- MESSAGE PAGE --------------------
class MessagePage extends StatefulWidget {
  const MessagePage({super.key});

  @override
  State<MessagePage> createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> {
  Map<String, dynamic>? selectedDoctor;

  @override
  Widget build(BuildContext context) {
    return selectedDoctor == null
        ? _doctorListView()
        : ChatPage(
            doctor: selectedDoctor!,
            onBack: () {
              setState(() => selectedDoctor = null);
            },
          );
  }

  Widget _doctorListView() {
    return Scaffold(
      appBar: AppBar(title: const Text("Messages")),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: doctors.length,
        itemBuilder: (context, index) {
          final doc = doctors[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              leading: CircleAvatar(
                backgroundImage: NetworkImage(doc['imageUrl']),
              ),
              title: Text(doc['name']),
              subtitle: Text(doc['specialty']),
              trailing: const Icon(Icons.chat, color: Color(0xFF4F46E5)),
              onTap: () {
                setState(() => selectedDoctor = doc);
              },
            ),
          );
        },
      ),
    );
  }
}

// -------------------- CHAT PAGE --------------------
class ChatPage extends StatefulWidget {
  final Map<String, dynamic> doctor;
  final VoidCallback onBack;

  const ChatPage({super.key, required this.doctor, required this.onBack});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, String>> messages = [];

  void sendMessage() {
    if (_controller.text.trim().isEmpty) return;

    setState(() {
      messages.add({"sender": "user", "text": _controller.text.trim()});
      _controller.clear();

      Future.delayed(const Duration(seconds: 1), () {
        setState(() {
          messages.add({
            "sender": "doctor",
            "text": "Thank you for your message!",
          });
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(widget.doctor['imageUrl']),
            ),
            const SizedBox(width: 10),
            Text(widget.doctor['name']),
          ],
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: widget.onBack,
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final msg = messages[index];
                bool isUser = msg['sender'] == 'user';
                return Align(
                  alignment: isUser
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: isUser
                          ? const Color(0xFF4F46E5)
                          : const Color(0xFFEFF1FF),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      msg['text']!,
                      style: TextStyle(
                        color: isUser ? Colors.white : Colors.black87,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const Divider(height: 1),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            color: Colors.white,
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      hintText: "Type a message...",
                      border: InputBorder.none,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send, color: Color(0xFF4F46E5)),
                  onPressed: sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// -------------------- SETTINGS PAGE --------------------
class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool notificationsEnabled = true;
  bool darkModeEnabled = false;

  String userEmail = supabase.auth.currentUser?.email ?? "user@email.com";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Settings")),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSectionTitle("Profile"),
          Card(
            child: ListTile(
              leading: const CircleAvatar(
                backgroundImage: NetworkImage(
                  "https://images.unsplash.com/photo-1607746882042-944635dfe10e?auto=format&fit=crop&w=400&q=80",
                ),
              ),
              title: const Text("User"),
              subtitle: Text(userEmail),
              trailing: IconButton(
                icon: const Icon(Icons.edit, color: Color(0xFF4F46E5)),
                onPressed: () => _editProfileDialog(),
              ),
            ),
          ),
          const SizedBox(height: 20),

          _buildSectionTitle("Account"),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.lock, color: Color(0xFF4F46E5)),
                  title: const Text("Change Password"),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () => _changePasswordDialog(),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.email, color: Color(0xFF4F46E5)),
                  title: const Text("Update Email"),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () => _updateEmailDialog(),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          _buildSectionTitle("Preferences"),
          Card(
            child: Column(
              children: [
                SwitchListTile(
                  activeColor: const Color(0xFF4F46E5),
                  title: const Text("Enable Notifications"),
                  value: notificationsEnabled,
                  onChanged: (val) {
                    setState(() => notificationsEnabled = val);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          "Notifications ${val ? "enabled" : "disabled"}",
                        ),
                      ),
                    );
                  },
                ),
                const Divider(height: 1),
                SwitchListTile(
                  activeColor: const Color(0xFF4F46E5),
                  title: const Text("Dark Mode"),
                  value: darkModeEnabled,
                  onChanged: (val) {
                    setState(() => darkModeEnabled = val);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          "Dark Mode ${val ? "enabled" : "disabled"}",
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          _buildSectionTitle("Support & Privacy"),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(
                    Icons.privacy_tip,
                    color: Color(0xFF4F46E5),
                  ),
                  title: const Text("Privacy Policy"),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const PrivacyPolicyPage(),
                    ),
                  ),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.help, color: Color(0xFF4F46E5)),
                  title: const Text("Help & Support"),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const HelpSupportPage()),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          ElevatedButton.icon(
            icon: const Icon(Icons.logout),
            label: const Text("Logout"),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
            onPressed: () async {
              await supabase.auth.signOut();
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const LoginPage()),
                (route) => false,
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(
        title.toUpperCase(),
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.grey,
          fontSize: 12,
        ),
      ),
    );
  }

  // ---------------- DIALOGS ----------------
  void _changePasswordDialog() {
    final newPasswordController = TextEditingController();
    final confirmPasswordController = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Change Password"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: newPasswordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: "New Password"),
            ),
            TextField(
              controller: confirmPasswordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: "Confirm Password"),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () async {
              if (newPasswordController.text !=
                  confirmPasswordController.text) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Passwords do not match!")),
                );
                return;
              }

              await supabase.auth.updateUser(
                UserAttributes(password: newPasswordController.text),
              );

              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Password updated successfully!")),
              );
            },
            child: const Text("Update"),
          ),
        ],
      ),
    );
  }

  void _updateEmailDialog() {
    final emailController = TextEditingController(text: userEmail);

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Update Email"),
        content: TextField(
          controller: emailController,
          decoration: const InputDecoration(labelText: "New Email"),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () async {
              await supabase.auth.updateUser(
                UserAttributes(email: emailController.text.trim()),
              );
              setState(() {
                userEmail = emailController.text.trim();
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Email updated successfully!")),
              );
            },
            child: const Text("Update"),
          ),
        ],
      ),
    );
  }

  void _editProfileDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Edit Profile"),
        content: const Text("Profile editing feature coming soon."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }
}

// ---------------- PRIVACY POLICY PAGE ----------------
class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Privacy Policy")),
      body: const Padding(
        padding: EdgeInsets.all(16),
        child: Text(
          "This is the Privacy Policy.\n\n"
          "Your data is safe with us and we do not share personal information.",
          style: TextStyle(color: Colors.black54),
        ),
      ),
    );
  }
}

// ---------------- HELP & SUPPORT PAGE ----------------
class HelpSupportPage extends StatelessWidget {
  const HelpSupportPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Help & Support")),
      body: const Padding(
        padding: EdgeInsets.all(16),
        child: Text(
          "For support, contact us at:\n\nsupport@hellocare.com\n\n"
          "You can also call us at +123-456-7890.",
          style: TextStyle(color: Colors.black54),
        ),
      ),
    );
  }
}
