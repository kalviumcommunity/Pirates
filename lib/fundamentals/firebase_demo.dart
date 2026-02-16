import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// IMPORTANT: Ensure you have followed the Firebase setup instructions in CONCEPT_2_README.md
// before running this file. You need google-services.json (Android) or GoogleService-Info.plist (iOS).

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize Firebase (make sure google-services.json is in android/app)
  await Firebase.initializeApp();
  runApp(const FirebaseDemoApp());
}

class FirebaseDemoApp extends StatelessWidget {
  const FirebaseDemoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Firebase Demo',
      theme: ThemeData(
        primarySwatch: Colors.amber,
        useMaterial3: true,
      ),
      // Use a StreamBuilder to listen to the authentication state changes.
      // This automatically updates the UI when the user logs in or out.
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasData) {
            // User is signed in
            return const TaskListScreen();
          }
          // User is not signed in
          return const AuthScreen();
        },
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// 3. Implement Firebase Authentication
// ---------------------------------------------------------------------------

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  String _errorMessage = '';
  bool _isLogin = true; // Toggle between Login and Sign Up

  Future<void> _submit() async {
    try {
      if (_isLogin) {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );
      } else {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );
      }
    } on FirebaseAuthException catch (e) {
      setState(() {
        _errorMessage = e.message ?? 'An error occurred';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_isLogin ? 'Login' : 'Sign Up')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            if (_errorMessage.isNotEmpty)
              Text(_errorMessage, style: const TextStyle(color: Colors.red)),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _submit,
              child: Text(_isLogin ? 'Login' : 'Sign Up'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _isLogin = !_isLogin;
                  _errorMessage = '';
                });
              },
              child: Text(_isLogin
                  ? 'Create an account'
                  : 'I already have an account'),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// 4. Integrate Firestore for Real-Time Data & 5. Real-Time UI
// ---------------------------------------------------------------------------

class TaskListScreen extends StatefulWidget {
  const TaskListScreen({super.key});

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  final _taskController = TextEditingController();
  final CollectionReference _tasksCollection =
      FirebaseFirestore.instance.collection('tasks');

  Future<void> _addTask() async {
    if (_taskController.text.isEmpty) return;
    try {
      // Add a new document with a generated ID
      await _tasksCollection.add({
        'title': _taskController.text.trim(),
        'createdAt': Timestamp.now(),
        'isDone': false,
        'userId': FirebaseAuth.instance.currentUser?.uid, // Optional: link task to user
      });
      _taskController.clear();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error adding task: $e')),
      );
    }
  }

  Future<void> _toggleTask(String id, bool currentStatus) async {
    await _tasksCollection.doc(id).update({'isDone': !currentStatus});
  }

  Future<void> _deleteTask(String id) async {
    await _tasksCollection.doc(id).delete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Real-Time Tasks'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => FirebaseAuth.instance.signOut(),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _taskController,
                    decoration: const InputDecoration(
                      hintText: 'Enter a task...',
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: _addTask,
                ),
              ],
            ),
          ),
          Expanded(
            // StreamBuilder listens to the Firestore collection stream.
            // Whenever data changes in the database (from ANY device),
            // this widget rebuilds with the new data instantaneously.
            child: StreamBuilder<QuerySnapshot>(
              stream: _tasksCollection
                  .orderBy('createdAt', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                final docs = snapshot.data!.docs;
                if (docs.isEmpty) {
                  return const Center(child: Text('No tasks yet. Add one!'));
                }

                return ListView.builder(
                  itemCount: docs.length,
                  itemBuilder: (context, index) {
                    final doc = docs[index];
                    final data = doc.data() as Map<String, dynamic>;
                    final id = doc.id;
                    final isDone = data['isDone'] ?? false;

                    return ListTile(
                      leading: Checkbox(
                        value: isDone,
                        onChanged: (_) => _toggleTask(id, isDone),
                      ),
                      title: Text(
                        data['title'] ?? 'Untitled',
                        style: TextStyle(
                          decoration:
                              isDone ? TextDecoration.lineThrough : null,
                        ),
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _deleteTask(id),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
