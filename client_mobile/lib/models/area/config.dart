/// Represents a configuration option.
class Config {
  /// The name of the configuration option.
  String name;

  /// The HTML form type associated with the configuration option.
  String htmlFormType;

  /// The value of the configuration option (can be `null`).
  String? value;

  /// The display text for the configuration option.
  String display;

  /// Indicates whether the configuration option is mandatory.
  bool mandatory;

  /// Constructor for the `Config` class.
  ///
  /// - `name`: The name of the configuration option.
  /// - `value`: The value of the configuration option (can be `null`).
  /// - `display`: The display text for the configuration option.
  /// - `mandatory`: Indicates whether the configuration option is mandatory.
  /// - `htmlFormType`: The HTML form type associated with the configuration option.
  Config({
    required this.name,
    this.value,
    required this.display,
    required this.mandatory,
    required this.htmlFormType,
  });

  /// Setter for the [value] property.
  set valueSet(String val) {
    value = val;
  }

  /// Convert the configuration option to a JSON map.
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'value': value,
      'display': display,
      'mandatory': mandatory,
      'htmlFormType': htmlFormType,
    };
  }

  /// Factory constructor to create a [Config] object from a JSON map.
  ///
  /// - [json]: A JSON map containing configuration option data.
  factory Config.fromJson(Map<String, dynamic> json) {
    return Config(
      name: json['name'],
      value: json['value'],
      display: json['display'],
      mandatory: json['mandatory'],
      htmlFormType: json['htmlFormType'],
    );
  }

  @override
  /// Returns a string representation of the configuration option.
  String toString() {
    return 'Config(name: $name, value: $value, display: $display, mandatory: $mandatory, htmlFormType: $htmlFormType)';
  }
}
