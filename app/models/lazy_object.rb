# frozen_string_literal: true

class LazyObject < BasicObject
  def initialize(&callable)
    @__callable__ = callable
  end

  # Cached target object.
  def __target_object__
    @__target_object__ ||= @__callable__.call
  end

  # Forwards all method calls to the target object.
  def method_missing(method_name, *args, &block)
    __target_object__.send(method_name, *args, &block)
  end
end
