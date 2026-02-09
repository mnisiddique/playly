require 'json'

def fire_sa_cred
    relative_path = File.expand_path("../../fire_sa_cred.json")
    return relative_path
end

def google_drive_sa_cred
    relative_path = File.expand_path("../../google_drive_sa_cred.json")
    return relative_path
end


def release_note(extra_note = nil)
  result = sh("gen release-note", capture: true).strip
  if extra_note && !extra_note.strip.empty?
    "Environment: #{extra_note.strip}\n\n#{result}"
  else
    result
  end
end


def version_name
    result = sh("gen sem-ver", capture: true)
    return result.strip
end

def read_deployment_info(path)
  file_path = path
  json_content = File.read(file_path)           # read file as string
  data = JSON.parse(json_content)               # parse JSON string into Ruby hash/array
  # If you want to return the entire data structure
  return data
end

def write_deployment_info(data, path)
  file_path = path
  json_content = JSON.pretty_generate(data)     # convert Ruby hash/array to JSON string
  File.write(file_path, json_content)           # write JSON string to file
end

def write_version_info(versionName, versionCode, path)
  file_path = path
  content = <<~PROPERTIES
versionName=#{versionName}
versionCode=#{versionCode}
PROPERTIES
  File.write(file_path, content)           # write properties to .properties file
end

def formate_deployment_info(deployment_info)
  dwnld_link = deployment_info['download_link']
  if dwnld_link.nil? || dwnld_link.empty?
    return "*#{deployment_info['platform_name']}*: `#{deployment_info['release_name']}`"
  end
  return "*#{deployment_info['platform_name']}*: [#{deployment_info['release_name']}](#{deployment_info['download_link']})"
end

