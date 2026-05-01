class ProfileRemoteDataSource {

  Future<Map<String, dynamic>> fetchProfile() async {
    // Firebase call later
    return {
      "name": "Engineer Ki soch",
      "email": "engineerkisoch@gmail.com",
      "pending": 0,
      "overdue": 0,
      "completed": 1,
      "streak": 0,
    };
  }
}