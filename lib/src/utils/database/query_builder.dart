class QueryBuilder {
  String _table = '';
  String _columns = '*';
  String _where = '';
  String _orWhere = '';
  String _orderBy = '';
  int? _limit;
  int? _offset;

  QueryBuilder table(String tableName) {
    _table = tableName;
    return this;
  }

  QueryBuilder select(List<String> columns) {
    _columns = columns.join(', ');
    return this;
  }

  QueryBuilder where(String column, String operator, dynamic value) {
    if (value != "") {
      if (operator == "LIKE" || operator == "like") {
        value = "%$value%";
      }
      if (_where.isEmpty) {
        _where += '$column $operator "$value" ';
      } else {
        _where += 'AND $column $operator "$value" ';
      }
    }
    return this;
  }

  QueryBuilder orWhere(String column, String operator, dynamic value) {
    if (value != "") {
      if (operator == "LIKE" || operator == "like") {
        value = "%$value%";
      }
      _orWhere += '${_orWhere.isEmpty ? '' : 'OR'} $column $operator "$value" ';
    }
    return this;
  }

  QueryBuilder orderBy(String column, [String direction = 'ASC']) {
    _orderBy = 'ORDER BY $column $direction';
    return this;
  }

  QueryBuilder limit(int limit) {
    _limit = limit;
    return this;
  }

  QueryBuilder offset(int offset) {
    _offset = offset;
    return this;
  }

  String execute() {
    if (_table.isEmpty) {
      throw Exception('Table name is not specified.');
    }

    String query = 'SELECT $_columns FROM $_table';

    if (_where.isNotEmpty) {
      query += ' WHERE $_where';
    }

    if (_orWhere.isNotEmpty) {
      query += ' AND ( $_orWhere )';
    }

    if (_orderBy.isNotEmpty) {
      query += ' $_orderBy';
    }

    if (_limit != null) {
      query += ' LIMIT $_limit';
    }

    if (_offset != null) {
      query += ' OFFSET $_offset';
    }

    return query;
  }
}
