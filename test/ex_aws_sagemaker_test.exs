defmodule ExAws.SagemakerTest do
  use ExUnit.Case
  doctest ExAws.Sagemaker

  test "greets the world" do
    assert ExAws.Sagemaker.hello() == :world
  end
end
