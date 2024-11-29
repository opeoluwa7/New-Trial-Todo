/*body: ValueListenableBuilder(
          valueListenable: dbProvider.todoBox.listenable(),
          builder: (context, box, _) {
            final todos = dbProvider.getAllTodos();
            if (todos.isEmpty) {
              return const Center(
                child: Text('No todos found'),
              );
            }
            return ListView.builder(
                itemCount: todos.length,
                itemBuilder: (context, index) {
                  final todo = todos[index];
                  return Container(
                      decoration: const BoxDecoration(
                        color: Colors.red,
                      ),
                      child: ListTile(title: Text(todo.title)));
                });
          }),*/
 /*StreamBuilder(
          stream: dbProvider.todoBox.watch(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator.adaptive(),
              );
            }
            if (snapshot.hasData) {
              final todos = dbProvider.getAllTodos();
              return ListView.builder(
                  itemCount: todos.length,
                  itemBuilder: (context, index) {
                    final todo = todos[index];

                    return ListTile(
                      title: Text(todo.title),
                    );
                  });
            } else {
              return const Center(
                child: Text('No documents found'),
              );
            }
          }),*/
/*  StreamBuilder(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final currentUser = snapshot.data;
                final user = currentUser?.uid;

                final userData = dbProvider.getUser(user!);

                return Center(
                  child: Column(
                    children: [
                      Text('Username: ${userData?.username}',),
                      Text('Email: ${userData?.email}'),
                      Text('Id: ${userData?.id}'),
                      
                    ],
                  ),
                );
              } else {
                return const Center(
                  child: Text('No user found'),
                );
              }
            },),*/

/*final userBox = Hive.box('users');
  final todoBox = Hive.box('todos');

  //add users
  void createUser(UserModel user) {
    userBox.put(user.id, user.toMap());
  }

  UserModel? getUser(String id) {
    final userMap = userBox.get(id);
    if (userMap != null) {
      final userFinalMap = Map<String, dynamic>.from(userMap);
      return UserModel.fromMap(userFinalMap);
    } else {
      return null; // Handle case where user is not found
    }
    //return UserModel.fromMap(userBox.get(id));
  }

  void deleteUser(String id) {
    userBox.delete(id);
  }

   createTodo(Todo todo) {
    todoBox.put(todo.id, todo.toMap());
    print('Todo saved to box: ${todo.toMap()}');
  print('Current todos in box: ${todoBox.values.toList()}');
  }

  Todo? getTodo(String id) {
    final todoMap = todoBox.get(id);
    if (todoMap == null) {
      return null;
    } else {
      final todoFinalMap = Map<String, dynamic>.from(todoMap);
      return Todo.fromMap(todoFinalMap);
      //return Todo.fromMap(todoMap);
    }
  }


  // Get all todos
  List<Todo> getAllTodos() {
    return todoBox.values
        .map((e) => Todo.fromMap(Map<String, dynamic>.from(e)))
        .toList();
  }

  void deleteTodo(String id) {
    todoBox.delete(id);
  }
  */

  /*StreamBuilder(
            stream: DbProvider().fetchUsers(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator.adaptive(),
                );
              }
              if (snapshot.hasData) {
                final usersData = snapshot.data?.docs;

                final userData = userId != null
                    ? usersData?.firstWhere(
                        (userDoc) => userDoc.id == userId,
                        orElse: () => null,
                      )
                    : null;

                if (userData != null && userData.data() != null) {
                  final user = UserModel.fromMap(
                      userData.data() as Map<String, dynamic>);

                  /*final user =
                UserModel.fromMap(userData?.data() as Map<String, dynamic>);*/

                  return Center(
                    child: Column(
                      children: [
                        Text(
                          'Username: ${user.username}',
                        ),
                      ],
                    ),
                  );
                } else {
                  return const Center(
                    child: Text('No User found'),
                  );
                }
              }
            })*/