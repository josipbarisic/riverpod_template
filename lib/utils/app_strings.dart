class AppStrings {
  static const String next = 'NEXT';
  static const String getStarted = 'GET STARTED';
  static const String continueBtn = 'Continue';
  static const String createYourAccount = 'Create Your Account';
  static const String continueWithGoogle = 'CONTINUE WITH GOOGLE';
  static const String continueWithApple = 'CONTINUE WITH APPLE';
  static const String alreadyHaveAnAccount = 'Already have an account?';
  static const String logIn = 'Log in';
  static const String orLogInWithEmail = 'OR LOG IN WITH EMAIL';
  static const String forgotPassword = 'Forgot Password';
  static const String dontHaveAnAccount = 'Don\'t have an account?';
  static const String join = 'Join';
  static const String continueSignup = 'Continue Signup';
  static const String firstNameAsterisk = 'FIRST NAME*';
  static const String lastNameAsterisk = 'LAST NAME*';
  static const String phoneNumberAsterisk = 'PHONE NUMBER*';
  static const String dateOfBirthAsterisk = 'DATE OF BIRTH*';
  static const String notifications = 'Notifications';
  static const String confirm = 'Confirm';
  static const String cancel = 'Cancel';
  static const String back = 'Back';
  static const String comingSoon = 'Coming soon...';
  static const String continueToProfile = 'CONTINUE TO PROFILE';
  static const String completeYourProfile = 'Complete\nYour Profile';
  static const String moreAboutYou = 'MORE ABOUT YOU:';
  static const String description = 'Description';
  static const String companyNameAsterisk = 'COMPANY NAME*';
  static const String titleAsterisk = 'TITLE*';
  static const String genderAsterisk = 'GENDER*';
  static const String primaryAddress = 'PRIMARY ADDRESS:';
  static const String secondaryAddress = 'SECONDARY ADDRESS:';
  static const String city = 'CITY';
  static const String state = 'STATE';
  static const String zipPostal = 'ZIP/POSTAL';
  static const String allergies = 'ALLERGIES:';
  static const String saveAndContinue = 'SAVE AND CONTINUE';
  static const String allSet = 'You’re All Set!';

  static String goodMorningUser(String userFirstName) => 'Good\nmorning,\n$userFirstName.';

  static String goodDayUser(String userFirstName) => 'Good day,\n$userFirstName.';

  static String goodEveningUser(String userFirstName) => 'Good\nevening,\n$userFirstName.';

  static String getWelcomeMessage(String userFirstName) {
    final hour = DateTime.now().hour;
    return hour < 11
        ? goodMorningUser(userFirstName)
        : hour < 18
            ? goodDayUser(userFirstName)
            : goodEveningUser(userFirstName);
  }

  static String seeAll = 'See All';
}

class ErrorStrings {
  static const String requestFailed = 'Request failed';
  static const String inviteCodeInvalid = 'Invite code is invalid.';
  static const String enterEmailAndPassword = 'Please enter your email and password';
  static const String mandatoryField = 'This field is mandatory';
  static const String enterValidEmail = 'Please enter a valid email address';
  static const String enterValidPassword = 'Please enter a valid password';
  static const String enterValidFirstName = 'Please enter a valid first name';
  static const String enterValidLastName = 'Please enter a valid last name';
  static const String enterValidPhoneNumber = 'Please enter a valid phone number';
  static const String enterDateOfBirth = 'Please enter your date of birth';
  static const String verificationCodeInvalid = 'Verification code is invalid.';
  static const String failedToAuthenticateUser =
      'Failed to authenticate the user. Please try again.';
  static const String failedToCreateUser = 'Failed to create a user. Please try again.';
}
