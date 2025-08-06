abstract class Either<L, R> {
  const Either();

  bool get isLeft;
  bool get isRight;

  L? get leftValue;
  R? get rightValue;

  Either<L, R2> map<R2>(R2 Function(R) f);
  Either<L2, R> mapLeft<L2>(L2 Function(L) f);
  R2 fold<R2>(R2 Function(L) onLeft, R2 Function(R) onRight);
}

class Left<L, R> extends Either<L, R> {
  final L value;
  const Left(this.value);

  @override
  bool get isLeft => true;
  @override
  bool get isRight => false;
  @override
  L? get leftValue => value;
  @override
  R? get rightValue => null;

  @override
  Either<L, R2> map<R2>(R2 Function(R) f) => Left(value);

  @override
  Either<L2, R> mapLeft<L2>(L2 Function(L) f) => Left(f(value));

  @override
  R2 fold<R2>(R2 Function(L) onLeft, R2 Function(R) onRight) => onLeft(value);
}

class Right<L, R> extends Either<L, R> {
  final R value;
  const Right(this.value);

  @override
  bool get isLeft => false;
  @override
  bool get isRight => true;
  @override
  L? get leftValue => null;
  @override
  R? get rightValue => value;

  @override
  Either<L, R2> map<R2>(R2 Function(R) f) => Right(f(value));

  @override
  Either<L2, R> mapLeft<L2>(L2 Function(L) f) => Right(value);

  @override
  R2 fold<R2>(R2 Function(L) onLeft, R2 Function(R) onRight) => onRight(value);
}
