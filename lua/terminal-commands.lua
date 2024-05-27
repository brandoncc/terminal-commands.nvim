local function create_terminal()
  local create_with = ":sp | terminal"

  vim.cmd(create_with)

  local buf_id = vim.api.nvim_get_current_buf()
  local term_id = vim.b.terminal_job_id

  if term_id == nil then
    error("term_id is nil, didn't create terminal")
    return nil
  end

  -- when the terminal exits, close the window
  vim.cmd("autocmd TermClose <buffer> quit")

  -- autoscroll by putting the cursor at the bottom of the buffer
  vim.cmd("norm! G")

  -- Make sure the term buffer has "hidden" set so it doesn't get thrown
  -- away and cause an error
  vim.api.nvim_buf_set_option(buf_id, "bufhidden", "hide")
  return term_id
end

local function send_command(term_id, command)
  -- if the command doesn't end with "\n", add it
  if not command:match("\n$") then
    command = command .. "\n"
  end

  vim.api.nvim_chan_send(term_id, command)
end

local function run_commands(commands)
  local term_id = create_terminal()

  for _, command in ipairs(commands) do
    send_command(term_id, command)
  end

  send_command(term_id, "exit")
end

return { run_commands = run_commands }
