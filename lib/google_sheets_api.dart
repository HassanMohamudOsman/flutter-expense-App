import 'package:gsheets/gsheets.dart';

class GoogleSheetsApi {
  // create credentials
  static const _credentials = r'''
   {
  "type": "service_account",
  "project_id": "expense-tracker-app-376304",
  "private_key_id": "e6a3b7e41fdb1d13d58fd22e61e2e5e7b273ab8e",
  "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvAIBADANBgkqhkiG9w0BAQEFAASCBKYwggSiAgEAAoIBAQCRbCIcdDuylSU2\nQi9w7YJo1vKrgWBB54KO8HaOWMVjPnZtn0wvM928ocEGfoY2Ub1O3PG/WrOCr2aN\nDu3UWNxAWL/eJHtaEHXx1VKd0VlbncwBk+Lh9lgPu3k0rxSZCniZMlRsLmuCvzIj\nKS3ilZ+YunuNeZ4IWMbvdeZr2ytp5Ww3O/Fg8OtRKLHD9JC/Htnp1OfzhqexZSm0\n48a7wzp0jor0Rsm4XC/2llL6tQqMr/1Lo4InlWk7Oh/IDsVVKhumPtD0MpB60vBZ\nKtoMSUTQL5nG8O5Bw+UgV0NTSj+93ZTN/epVUSiym7lFlSvKeLammxCtc9b4dT0c\nQ4gcM+/NAgMBAAECggEAGDSL/vl34FND9OKSW/Ukoke478QingWnbRxoV2w+OrUw\naDG+MBMtgtLXurl/pHX5kTFkicnSnFuOscb83j4GNy2ujg67e3PG9gBgdoVcnsvG\no7KWbq8e3EuDsrm7r3eXOESw2armWUZy1Xhqu07VWEod+5/1JoWEY2JX/rbl5IO7\nwoUes7DdSiF8RupIhKPcaCk2CcQS/rf1DM15AdFLSlENyWcbwjNUfaUnRXZyfN90\nwC2mWuC1ciupxqLyUWcibzl81paM8YKXXyJk71xlKCN0nyeEST8+fi2plT4N9KaB\noDOaQbNafCNraNLH4WvRZz3M9AtS8oa1f9uhGMKzTwKBgQDBnaycP9WqbpvcfCrg\nLqSTwhm8I1PdHpIzXycdqOeVWvbZhFdlMzB+2xhyVdCyIxuW3njx+WQaDybv+ptU\n9GCTgov+3foN9L1GgRNh03trWcLq9hUR9bSOVy26QbdZJEfDrNQ/3VpNbzF+Rns8\ng9tRxJ+LKMFN2tp3iES1q/BUtwKBgQDARzy4XjEjRL7Ja3Iq547puej/1bv0jQFR\nHVHKu0rDWPisBGVQtLz0MOogFkKtB8FBlCAYgUqEmYngiFUnmIZSzNVyNO5fuCoV\nVW19Xfs2axY+jezOR9LAOqNH7IPFY1QHoQK+y+UQPg4GGBQWHEwm9hD3eHbPVdF/\nmFt/e2GDmwKBgH3PD+9Dx3oEf4Coqk+b31Mn6AMJTaA8EjIRXWB3dWvmfMpgpU1c\nEuILSfpZas+l4nKJQzuwmuwX9mwvgqmUVgDj7kYBRU+2PRtIGikR+3uJCxAUMSLH\nbrijS1JhC1uAKKWscwrAscHpQ9bSw5dR8rxSMH2DUQBe+mB7inImNHdHAoGABxFX\nSQulUL+RJ8Q8URlr5mmACA9qNkYMm1exjvstd1rI4UHUG5BZNbyqjn1i/AtB7lAs\nkdoGzDL8n3VDdA4mOdrvqaAKdxhE673VJXuT5V8wVSJQZxC6zXgaUmV+Pn41M4aW\nnD7Qb7VoPI8cBegKYJBA9WfHLj3gUoleK6R0ZCsCgYAe9BJEQWpN+5gy0N5J0QxS\ngZvu8UC074ywlxKPPi5ulnay6DFac3+u4QPIEMreSEC+BQNPfpqrrlZYIUScATq6\nUXIzls9ks8rVYYc7vwEJ877doGIOo+36N+n1IAVNj1dWDZZlYOgWhvXVP4XgY1u/\neGQUeTP1kXOmH2nsR73ETw==\n-----END PRIVATE KEY-----\n",
  "client_email": "expense-tracker-app@expense-tracker-app-376304.iam.gserviceaccount.com",
  "client_id": "116296347645355321748",
  "auth_uri": "https://accounts.google.com/o/oauth2/auth",
  "token_uri": "https://oauth2.googleapis.com/token",
  "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
  "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/expense-tracker-app%40expense-tracker-app-376304.iam.gserviceaccount.com"
}
  ''';

  // set up & connect to the spreadsheet
  static final _spreadsheetId = '1RiUdRknRuYpmFXr06rmspHvTnVgVpL3g94jIZ9aaxWk';
  static final _gsheets = GSheets(_credentials);
  static Worksheet? _worksheet;

  // some variables to keep track of..
  static int numberOfTransactions = 0;
  static List<List<dynamic>> currentTransactions = [];
  static bool loading = true;

  // initialise the spreadsheet!
  Future init() async {
    final ss = await _gsheets.spreadsheet(_spreadsheetId);
    _worksheet = ss.worksheetByTitle('Worksheet1');
    countRows();
  }

  // count the number of notes
  static Future countRows() async {
    while ((await _worksheet!.values
            .value(column: 1, row: numberOfTransactions + 1)) !=
        '') {
      numberOfTransactions++;
    }
    // now we know how many notes to load, now let's load them!
    loadTransactions();
  }

  // load existing notes from the spreadsheet
  static Future loadTransactions() async {
    if (_worksheet == null) return;

    for (int i = 1; i < numberOfTransactions; i++) {
      final String transactionName =
          await _worksheet!.values.value(column: 1, row: i + 1);
      final String transactionAmount =
          await _worksheet!.values.value(column: 2, row: i + 1);
      final String transactionType =
          await _worksheet!.values.value(column: 3, row: i + 1);

      if (currentTransactions.length < numberOfTransactions) {
        currentTransactions.add([
          transactionName,
          transactionAmount,
          transactionType,
        ]);
      }
    }
    print(currentTransactions);
    // this will stop the circular loading indicator
    loading = false;
  }

  // insert a new transaction
  static Future insert(String name, String amount, bool _isIncome) async {
    if (_worksheet == null) return;
    numberOfTransactions++;
    currentTransactions.add([
      name,
      amount,
      _isIncome == true ? 'income' : 'expense',
    ]);
    await _worksheet!.values.appendRow([
      name,
      amount,
      _isIncome == true ? 'income' : 'expense',
    ]);
  }

  // CALCULATE THE TOTAL INCOME!
  static double calculateIncome() {
    double totalIncome = 0;
    for (int i = 0; i < currentTransactions.length; i++) {
      if (currentTransactions[i][2] == 'income') {
        totalIncome += double.parse(currentTransactions[i][1]);
      }
    }
    return totalIncome;
  }

  // CALCULATE THE TOTAL EXPENSE!
  static double calculateExpense() {
    double totalExpense = 0;
    for (int i = 0; i < currentTransactions.length; i++) {
      if (currentTransactions[i][2] == 'expense') {
        totalExpense += double.parse(currentTransactions[i][1]);
      }
    }
    return totalExpense;
  }
}
