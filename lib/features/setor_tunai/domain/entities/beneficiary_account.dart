class BeneficiaryAccount {
  final String id;
  final String accountNumber;
  final String accountName;
  final String? bankName;
  final String? branchName;

  const BeneficiaryAccount({
    required this.id,
    required this.accountNumber,
    required this.accountName,
    this.bankName,
    this.branchName,
  });

  factory BeneficiaryAccount.fromJson(Map<String, dynamic> json) {
    return BeneficiaryAccount(
      id: json['id'].toString(),
      accountNumber: json['account_number'] as String,
      accountName: json['account_name'] as String,
      bankName: json['bank_name'] as String?,
      branchName: json['branch_name'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'account_number': accountNumber,
      'account_name': accountName,
      'bank_name': bankName,
      'branch_name': branchName,
    };
  }

  @override
  String toString() {
    return '$accountName - $accountNumber';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is BeneficiaryAccount && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
