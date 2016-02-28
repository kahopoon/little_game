def start_dimension()
  status = []
  dimension = 0
  loop do
    puts("Please enter width / height (1 to 20)")
    dimension = gets().to_i
    break if (dimension >= 1 && dimension <= 20)
  end
  for i in 0..dimension-1
    status[i] = []
    for j in 0..dimension-1
      status[i][j] = ((dimension * i) + (j+1)).to_s
    end
  end
  return status
end

def refresh_screen()
  refresh = ""
  for loop in 0..50
    refresh += "\n"
  end
  puts(refresh)
end

def show_grid(status)
  horizontal_line = "-"
  for k in 0..status.size-1
    horizontal_line += "-------"
  end
  puts(horizontal_line)
  for i in 0..status.size-1
    show = ""
    for j in 0..status.size-1
      if status[i][j].size == 1
        show += "|   " + status[i][j] + "  "
      elsif status[i][j].size == 2
        show += "|  " + status[i][j] + "  "
      elsif status[i][j].size == 3
        show += "| " + status[i][j] + "  "
      end
    end
    show += "|"
    puts(show,horizontal_line)
  end
end

def number_to_gridPosition(status, num)
  num % status.size == 0? row = num / status.size - 1 : row = num / status.size
  num % status.size == 0? column = status.size - 1 : column = num % status.size - 1
  return {"row" => row, "column" => column}
end

def is_available(status, grid_position)
  return (status[grid_position["row"]][grid_position["column"]] != "O") && (status[grid_position["row"]][grid_position["column"]] != "X")? true:false
end

def human_action(status)
  input = 0
  grid_position = {}
  loop do
    puts ("Please enter 1 - " + (status.size * status.size).to_s)
    input = gets().to_i
    grid_position = number_to_gridPosition(status, input)
  break if (input > 0 && input <= status.size * status.size) && (is_available(status,grid_position))
  end
  status[grid_position["row"]][grid_position["column"]] = "O"
  return true
end

def computer_action(status)
  computer_turn = number_to_gridPosition(status, rand(status.size * status.size)+1)
  while !is_available(status, computer_turn)
    computer_turn = number_to_gridPosition(status, rand(status.size * status.size)+1)
  end
  status[computer_turn["row"]][computer_turn["column"]] = "X"
  return true
end

def is_win(side, status)
  side == "Circle" ? side = "O" * status.size : side = "X" * status.size
  result_horizontal, result_vertical = "",""
  for i in 0..status.size-1
    for k in 0..status.size-1
      result_horizontal += status[i][k]
      result_vertical += status[k][i]
    end
    if (result_horizontal == side || result_vertical == side)
      return true
    end
    result_horizontal.clear
    result_vertical.clear
  end
  result_leftcross, result_rightcross = "",""
  for i in 0..status.size-1
    result_leftcross += status[i][i]
    result_rightcross += status[i][status.size-1 - i]
  end
  if (result_leftcross == side || result_rightcross == side)
    return true
  end
  return false
end

def end_of_game(status)
  for i in 0..status.size-1
    for k in 0..status.size-1
      if status[i][k] != "O" && status[i][k] != "X"
        return false
      end
    end
  end
  return true
end

status = start_dimension()
win_side = ""
while (!end_of_game(status))
  refresh_screen()
  show_grid(status)
  if human_action(status)
    if is_win("Circle",status)
      win_side = "You Win!"
      break
    end
  end
  if computer_action(status)
    if is_win("Cross",status)
      win_side = "Computer Win!"
      break
    end
  end
end
refresh_screen
show_grid(status)
win_side.size == 0? puts("Round Draw!") : puts(win_side)
