def start_dimension()
  status = []
  dimension = 0
  loop do
    puts("Please enter width / height (1 to 20), enter 'q' to quit")
    input = gets()
    if input == "q\n"
      return []
    else
      dimension = input.to_i
    end
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

def computer_startround(status)
  if status.size % 2 != 0
    computer_turn = number_to_gridPosition(status, (status.size*status.size + 1) / 2)
    print computer_turn
    if is_available(status, computer_turn)
      status[computer_turn["row"]][computer_turn["column"]] = "X"
      return true
    end
  end
  corner = [1,status.size,status.size*2+1,status.size*status.size]
  computer_turn = rand(4)
  while !is_available(status, number_to_gridPosition(status, corner[computer_turn])) && corner.size > 0
    corn.delete_at(computer_turn)
    computer_turn = rand(4)
  end
  computer_turn = number_to_gridPosition(status, corner[computer_turn])
  if is_available(status, computer_turn)
    status[computer_turn["row"]][computer_turn["column"]] = "X"
    return true
  end
  return false
end

def computer_random(status)
  computer_turn = number_to_gridPosition(status, rand(status.size * status.size)+1)
  while !is_available(status, computer_turn)
    computer_turn = number_to_gridPosition(status, rand(status.size * status.size)+1)
  end
  if is_available(status, computer_turn)
    status[computer_turn["row"]][computer_turn["column"]] = "X"
    return true
  end
  return false
end

def computer_AI(status)
  if !computer_startround(status)
    side = "X"
    opp = "O"
    opp_count_limit = 2
    self_count_least = 1
    horizontal_selfCount, horizontal_oppCount, vertical_selfCount, vertical_oppCount = 0,0,0,0
    horizontal_available_list, vertical_available_list = [],[]
    for i in 0..status.size-1
      for k in 0..status.size-1
        status[i][k] == side ? horizontal_selfCount += 1 : horizontal_selfCount += 0
        status[i][k] == opp ? horizontal_oppCount += 1 : horizontal_oppCount += 0
        status[k][i] == side ? vertical_selfCount += 1 : vertical_selfCount += 0
        status[k][i] == opp ? vertical_oppCount += 1 : vertical_oppCount += 0
        if is_available(status, {"row" => i, "column" => k})
          horizontal_available_list.push(k)
        end
        if is_available(status, {"row" => k, "column" => i})
          vertical_available_list.push(k)
        end
      end
      if (horizontal_selfCount < self_count_least && horizontal_oppCount >= opp_count_limit) && horizontal_available_list.size > 0
        random_from_all_available = rand(horizontal_available_list.size)
        status[i][horizontal_available_list[random_from_all_available]] = side
        return true
      end
      if (vertical_selfCount < self_count_least && vertical_oppCount >= opp_count_limit) && vertical_available_list.size > 0
        random_from_all_available = rand(vertical_available_list.size)
        status[vertical_available_list[random_from_all_available]][i] = side
        return true
      end
      horizontal_selfCount, horizontal_oppCount, vertical_selfCount, vertical_oppCount = 0,0,0,0
      horizontal_available_list.clear
      vertical_available_list.clear
    end
    leftcross_selfCount, leftcross_oppCount, rightcross_selfCount, rightcross_oppCount = 0,0,0,0
    leftcross_available_list, rightcross_available_list = [],[]
    for i in 0..status.size-1
      status[i][i] == side ? leftcross_selfCount += 1 : leftcross_selfCount += 0
      status[i][i] == opp ? leftcross_oppCount += 1 : leftcross_oppCount += 0
      status[i][status.size-1 - i] == side ? rightcross_selfCount += 1 : rightcross_selfCount += 0
      status[i][status.size-1 - i] == opp ? rightcross_oppCount += 1 : rightcross_oppCount += 0
      if is_available(status, {"row" => i, "column" => i})
        leftcross_available_list.push(i)
      end
      if is_available(status, {"row" => i, "column" => status.size-1 - i})
        rightcross_available_list.push(i)
      end
    end
    if (leftcross_selfCount < self_count_least && leftcross_oppCount >= opp_count_limit) && leftcross_available_list.size > 0
      random_from_all_available = rand(leftcross_available_list.size)
      status[leftcross_available_list[random_from_all_available]][leftcross_available_list[random_from_all_available]] = side
      return true
    end
    if (rightcross_selfCount < self_count_least && rightcross_oppCount >= opp_count_limit) && rightcross_available_list.size > 0
      random_from_all_available = rand(rightcross_available_list.size)
      status[rightcross_available_list[random_from_all_available]][status.size-1 - rightcross_available_list[random_from_all_available]] = side
      return true
    end
    return computer_random(status)
  end
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

def game_sequence(status)
  win_side = ""
  while (!end_of_game(status))
    refresh_screen()
    show_grid(status)
    if !end_of_game(status)
      human_action(status)
      if is_win("Circle",status)
        win_side = "You Win!"
        break
      end
    end
    if !end_of_game(status)
      computer_AI(status)
      if is_win("Cross",status)
        win_side = "Computer Win!"
        break
      end
    end
  end
  return win_side
end

while (true)
  status = start_dimension()
  status.size == 0 ? break : win_side = game_sequence(status)
  refresh_screen()
  show_grid(status)
  win_side.size == 0? puts("Round Draw!") : puts(win_side)
end
