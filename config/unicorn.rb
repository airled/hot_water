@dir = "/home/airled/mina_test/current/"
# @dir = "/home/air/hot_water/"

worker_processes 2
working_directory @dir

timeout 30

# listen "#{@dir}unicorn.sock", :backlog => 64
listen 3000 

pid "#{@dir}unicorn.pid"

stderr_path "#{@dir}unicorn.stderr.log"
stdout_path "#{@dir}unicorn.stdout.log"