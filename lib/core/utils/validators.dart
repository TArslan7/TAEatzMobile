class Validators {
  // Email validation
  static String? email(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    
    final emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    if (!emailRegex.hasMatch(value)) {
      return 'Please enter a valid email address';
    }
    
    return null;
  }
  
  // Password validation
  static String? password(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    
    if (value.length < 8) {
      return 'Password must be at least 8 characters long';
    }
    
    if (!RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)').hasMatch(value)) {
      return 'Password must contain at least one uppercase letter, one lowercase letter, and one number';
    }
    
    return null;
  }
  
  // Confirm password validation
  static String? confirmPassword(String? value, String? password) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }
    
    if (value != password) {
      return 'Passwords do not match';
    }
    
    return null;
  }
  
  // Phone number validation
  static String? phoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Phone number is required';
    }
    
    // Remove all non-digit characters
    final cleanValue = value.replaceAll(RegExp(r'[^\d]'), '');
    
    if (cleanValue.length < 10) {
      return 'Please enter a valid phone number';
    }
    
    return null;
  }
  
  // Name validation
  static String? name(String? value, {String? fieldName}) {
    if (value == null || value.isEmpty) {
      return '${fieldName ?? 'Name'} is required';
    }
    
    if (value.length < 2) {
      return '${fieldName ?? 'Name'} must be at least 2 characters long';
    }
    
    if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(value)) {
      return '${fieldName ?? 'Name'} can only contain letters and spaces';
    }
    
    return null;
  }
  
  // Required field validation
  static String? required(String? value, {String? fieldName}) {
    if (value == null || value.isEmpty) {
      return '${fieldName ?? 'This field'} is required';
    }
    return null;
  }
  
  // Minimum length validation
  static String? minLength(String? value, int minLength, {String? fieldName}) {
    if (value == null || value.isEmpty) {
      return '${fieldName ?? 'This field'} is required';
    }
    
    if (value.length < minLength) {
      return '${fieldName ?? 'This field'} must be at least $minLength characters long';
    }
    
    return null;
  }
  
  // Maximum length validation
  static String? maxLength(String? value, int maxLength, {String? fieldName}) {
    if (value == null || value.isEmpty) {
      return null; // Let required validator handle empty values
    }
    
    if (value.length > maxLength) {
      return '${fieldName ?? 'This field'} must be no more than $maxLength characters long';
    }
    
    return null;
  }
  
  // Numeric validation
  static String? numeric(String? value, {String? fieldName}) {
    if (value == null || value.isEmpty) {
      return '${fieldName ?? 'This field'} is required';
    }
    
    if (double.tryParse(value) == null) {
      return '${fieldName ?? 'This field'} must be a valid number';
    }
    
    return null;
  }
  
  // Positive number validation
  static String? positiveNumber(String? value, {String? fieldName}) {
    final numericError = numeric(value, fieldName: fieldName);
    if (numericError != null) return numericError;
    
    final num = double.parse(value!);
    if (num <= 0) {
      return '${fieldName ?? 'This field'} must be greater than 0';
    }
    
    return null;
  }
  
  // Postal code validation (Dutch format)
  static String? postalCode(String? value) {
    if (value == null || value.isEmpty) {
      return 'Postal code is required';
    }
    
    final cleanValue = value.replaceAll(' ', '').toUpperCase();
    final postalCodeRegex = RegExp(r'^[1-9][0-9]{3}[A-Z]{2}$');
    
    if (!postalCodeRegex.hasMatch(cleanValue)) {
      return 'Please enter a valid Dutch postal code (e.g., 1234AB)';
    }
    
    return null;
  }
  
  // Credit card number validation (Luhn algorithm)
  static String? creditCardNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Card number is required';
    }
    
    final cleanValue = value.replaceAll(RegExp(r'[^\d]'), '');
    
    if (cleanValue.length < 13 || cleanValue.length > 19) {
      return 'Please enter a valid card number';
    }
    
    // Luhn algorithm
    int sum = 0;
    bool alternate = false;
    
    for (int i = cleanValue.length - 1; i >= 0; i--) {
      int digit = int.parse(cleanValue[i]);
      
      if (alternate) {
        digit *= 2;
        if (digit > 9) {
          digit = (digit % 10) + 1;
        }
      }
      
      sum += digit;
      alternate = !alternate;
    }
    
    if (sum % 10 != 0) {
      return 'Please enter a valid card number';
    }
    
    return null;
  }
  
  // CVV validation
  static String? cvv(String? value) {
    if (value == null || value.isEmpty) {
      return 'CVV is required';
    }
    
    final cleanValue = value.replaceAll(RegExp(r'[^\d]'), '');
    
    if (cleanValue.length < 3 || cleanValue.length > 4) {
      return 'Please enter a valid CVV';
    }
    
    return null;
  }
  
  // Expiry date validation
  static String? expiryDate(String? value) {
    if (value == null || value.isEmpty) {
      return 'Expiry date is required';
    }
    
    final cleanValue = value.replaceAll(RegExp(r'[^\d/]'), '');
    final parts = cleanValue.split('/');
    
    if (parts.length != 2) {
      return 'Please enter a valid expiry date (MM/YY)';
    }
    
    final month = int.tryParse(parts[0]);
    final year = int.tryParse(parts[1]);
    
    if (month == null || year == null) {
      return 'Please enter a valid expiry date (MM/YY)';
    }
    
    if (month < 1 || month > 12) {
      return 'Month must be between 01 and 12';
    }
    
    final currentYear = DateTime.now().year % 100;
    final currentMonth = DateTime.now().month;
    
    if (year < currentYear || (year == currentYear && month < currentMonth)) {
      return 'Card has expired';
    }
    
    return null;
  }
  
  // Address validation
  static String? address(String? value) {
    if (value == null || value.isEmpty) {
      return 'Address is required';
    }
    
    if (value.length < 5) {
      return 'Please enter a complete address';
    }
    
    return null;
  }
  
  // City validation
  static String? city(String? value) {
    if (value == null || value.isEmpty) {
      return 'City is required';
    }
    
    if (value.length < 2) {
      return 'Please enter a valid city name';
    }
    
    return null;
  }
  
  // Rating validation
  static String? rating(double? value) {
    if (value == null) {
      return 'Rating is required';
    }
    
    if (value < 1.0 || value > 5.0) {
      return 'Rating must be between 1 and 5';
    }
    
    return null;
  }
  
  // Comment validation
  static String? comment(String? value, {int? maxLength}) {
    if (value == null || value.isEmpty) {
      return null; // Comments are usually optional
    }
    
    if (maxLength != null && value.length > maxLength) {
      return 'Comment must be no more than $maxLength characters long';
    }
    
    return null;
  }
}
