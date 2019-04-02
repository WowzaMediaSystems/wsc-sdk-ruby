$model_data = {}
def add_model_data(path, data)
  type, name = model_type_and_name(path)

  $model_data ||= {}
  $model_data[type.to_sym] ||= {}
  $model_data[type.to_sym][name.to_sym] = data
end

def get_model_data(path)
  type, name = model_type_and_name(path)
  $model_data.try(:[], type.to_sym).try(:[], name.to_sym)
end


def model_type_and_name(path)
  parts = path.split("/", 2).map{ |p| p.gsub("/", "_").to_sym }
  type = parts.fetch(0, nil)
  name = parts.fetch(1, nil)
  return type, name
end
