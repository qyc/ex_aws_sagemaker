defmodule ExAws.Sagemaker do
  import ExAws.Utils, only: [camelize_keys: 1]

  @namespace "SageMaker"

  ## Notebook Instances
  ######################

  @type create_notebook_instance_opts :: [
    {:kms_key_id, binary} |
    {:security_group_ids, nonempty_list(binary)} |
    {:subnet_id, binary} |
    {:tags, %{required(binary) => binary}}
  ]
  @spec create_notebook_instance(instance_type :: binary, notebook_instance_name :: binary, role_arn :: binary) :: ExAws.Operation.JSON.t
  @spec create_notebook_instance(instance_type :: binary, notebook_instance_name :: binary, role_arn :: binary, opts :: create_notebook_instance_opts) :: ExAws.Operation.JSON.t
  def create_notebook_instance(instance_type, notebook_instance_name, role_arn, opts \\ []) do
    opts =
      case Keyword.pop(opts, :tags) do
        {nil, _} -> opts
        {tags, opts} -> Keyword.put(opts, :tags, convert_tags_map(tags))
      end

    data =
      opts
      |> camelize_keys
      |> Map.merge(%{
          "InstanceType" => instance_type,
          "NotebookInstanceName" => notebook_instance_name,
          "RoleArn" => role_arn
        })

    request(:create_notebook_instance, data)
  end

  @type create_presigned_notebook_instance_url_opts :: [
    {:session_expiration_duration_in_seconds, number}
  ]
  @spec create_presigned_notebook_instance_url(notebook_instance_name :: binary) :: ExAws.Operation.JSON.t
  @spec create_presigned_notebook_instance_url(notebook_instance_name :: binary, opts :: create_presigned_notebook_instance_url_opts) :: ExAws.Operation.JSON.t
  def create_presigned_notebook_instance_url(notebook_instance_name, opts \\ []) do
    data =
      opts
      |> camelize_keys
      |> Map.merge(%{
          "NotebookInstanceName" => notebook_instance_name
        })

    request(:create_presigned_notebook_instance_url, data)
  end

  @spec delete_notebook_instance(notebook_instance_name :: binary) :: ExAws.Operation.JSON.t
  def delete_notebook_instance(notebook_instance_name) do
    request(:delete_notebook_instance, %{"NotebookInstanceName" => notebook_instance_name})
  end

  @spec describe_notebook_instance(notebook_instance_name :: binary) :: ExAws.Operation.JSON.t
  def describe_notebook_instance(notebook_instance_name) do
    request(:describe_notebook_instance, %{"NotebookInstanceName" => notebook_instance_name})
  end

  @type list_notebook_instances_opts :: [
    {:creation_time_after, number} |
    {:creation_time_before, number} |
    {:last_modified_time_after, number} |
    {:last_modified_time_before, number} |
    {:max_results, pos_integer} |
    {:name_contains, binary} |
    {:next_token, binary} |
    {:sort_by, binary} |
    {:sort_order, binary} |
    {:status_equals, binary}
  ]
  @spec list_notebook_instances() :: ExAws.Operation.JSON.t
  @spec list_notebook_instances(opts :: list_notebook_instances_opts) :: ExAws.Operation.JSON.t
  def list_notebook_instances(opts \\ []) do
    data =
      opts
      |> camelize_keys
      |> Map.merge(%{})

    request(:list_notebook_instances, data)
  end

  @spec start_notebook_instance(notebook_instance_name :: binary) :: ExAws.Operation.JSON.t
  def start_notebook_instance(notebook_instance_name) do
    request(:start_notebook_instance, %{"NotebookInstanceName" => notebook_instance_name})
  end

  @spec stop_notebook_instance(notebook_instance_name :: binary) :: ExAws.Operation.JSON.t
  def stop_notebook_instance(notebook_instance_name) do
    request(:stop_notebook_instance, %{"NotebookInstanceName" => notebook_instance_name})
  end

  @type update_notebook_instance_opts :: [
    {:instance_type, binary} |
    {:role_arn, binary}
  ]
  @spec update_notebook_instance(notebook_instance_name :: binary) :: ExAws.Operation.JSON.t
  @spec update_notebook_instance(notebook_instance_name :: binary, opts :: update_notebook_instance_opts) :: ExAws.Operation.JSON.t
  def update_notebook_instance(notebook_instance_name, opts \\ []) do
    data =
      opts
      |> camelize_keys
      |> Map.merge(%{
          "NotebookInstanceName" => notebook_instance_name
        })

    request(:update_notebook_instance, data)
  end

  defp request(op, data, opts \\ %{}) do
    operation =
      op
      |> Atom.to_string
      |> Macro.camelize

    ExAws.Operation.JSON.new(:sagemaker, %{
      data: data,
      headers: [
        {"x-amz-target", "#{@namespace}.#{operation}"},
        {"content-type", "application/x-amz-json-1.1"}
      ]
    } |> Map.merge(opts))
  end

  defp convert_tags_map(%{} = tags) do
    tags
    |> Map.to_list
    |> Enum.map(fn {k, v} ->
        %{"Key" => k, "Value" => v}
      end)
  end
end
