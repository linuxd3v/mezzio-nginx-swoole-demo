<?php

declare(strict_types=1);

return [
    //Disable debug mode
    'debug' => false,

    //Lets disable cache - we dont need it with swoole as its all in memory
    \Laminas\ConfigAggregator\ConfigAggregator::ENABLE_CACHE => false,

    'mezzio-swoole' => [
        'enable_coroutine'   => true,
        'swoole-http-server' => [
            'process-name'   => 'somalia',
            'host'           => '0.0.0.0',
            //'port'           => 9601,
            //'mode'           => SWOOLE_PROCESS,
            'options'        => [
                //Enable swoole awesomeness
                'task_enable_coroutine' => true,
                
                //Make sure we set some max on conection number
                'max_conn' => 1024,

                // Enable task workers.
                //'task_worker_num' => 3,
                
                // Change number of workers 
                //'worker_num' => 6,

                //Safety feature to avoid memory leaks.
                //A worker process is restarted to avoid memory leak when receiving max_request + rand(0, max_request_grace) requests.
                'max_request' => 6000,

                //Increase to avoid this error:
                //WARNING	Worker_reactor_try_to_exit() (ERRNO 9012): worker exit timeout, forced termination
                'max_wait_time' => 10,

                // PID file
                'pid_file' => '/appdata/example-com.pid',
            ],

            //Static files shoud be served from nginx instead - for performance
            'static-files' => [
                'enable' => false,
            ],
        ],
    ],
];
