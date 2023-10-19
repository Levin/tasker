good_task = fn -> 
  Process.sleep(5000)
  {:ok, []}
  end

bad_task = fn -> 
  Process.sleep(5000)
  :error
  end
