namespace * guitars

struct Guitar {
  1: i64 id,
  2: string brand,
  3: string model,
}

enum ErrorType {
  NO_SUCH_RECORD_ID
}

exception Error {
  1: ErrorType err_code
}

service Guitars {
  Guitar create(1:string brand, 2:string model),
  Guitar show(1:i64 id) throws (1: Error error),
  Guitar remove(1:i64 id) throws (1: Error error),
  list<Guitar> all(),
}
