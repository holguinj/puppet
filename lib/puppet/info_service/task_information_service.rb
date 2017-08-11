class Puppet::InfoService::TaskInformationService

  def self.tasks_per_environment(environment_name)
    # get the actual environment object, raise error if the named env doesn't exist
    env = Puppet.lookup(:environments).get!(environment_name)
    return [] unless env

    env.modules.map do |mod|
      mod.tasks.map do |task|
        {:module => {:name => task.module.name}, :name => task.name}
      end
    end.flatten
  end

  def self.task_data(environment_name, module_name, task_name)
    # raise EnvironmentNotFound if applicable
    Puppet.lookup(:environments).get!(environment_name)

    pup_module = Puppet::Module.find(module_name, environment_name)
    raise Puppet::Module::MissingModule unless pup_module

    task = pup_module.tasks.find { |t| t.name == task_name }
    raise Puppet::Module::Task::TaskNotFound unless task

    {:metadata_file => task.metadata_file,
     :files => task.files}
  end
end
