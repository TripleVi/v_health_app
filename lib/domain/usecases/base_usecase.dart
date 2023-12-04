abstract class BaseUseCase<T, P> {
  T call({required P params});
}