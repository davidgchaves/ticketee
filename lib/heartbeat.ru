###              [status_code, headers, body]
run lambda { |_| [200, {'Content-Type' => 'text/plain'}, ['OK']] }
