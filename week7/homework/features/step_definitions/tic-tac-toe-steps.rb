require 'rspec/mocks/standalone'
require 'rspec/expectations'

require File.expand_path(File.dirname(__FILE__) + "/../../lib/tic_tac_toe")

Given /^I start a new Tic\-Tac\-Toe game$/ do
  @game = TicTacToe.new
end

When /^I enter my name (\w+)$/ do |name|
  @game.player = name
end

Then /^the computer welcomes me to the game with "(.*?)"$/ do |arg1|
  @game.welcome_player.expect eq arg1
end

Then /^randomly chooses who goes first$/ do
  [@game.player, "Computer"].expect include @game.current_player
end

Then /^who is X and who is O$/ do
  TicTacToe::SYMBOLS.expect include @game.player_symbol, @game.computer_symbol
end

Given /^I have a started Tic\-Tac\-Toe game$/ do
  @game = TicTacToe.new(:player)
  @game.player = "Renee"
end

Given /^it is my turn$/ do
  @game.current_player.expect eq "Renee"
end

Given /^the computer knows my name is Renee$/ do
  @game.player.expect eq "Renee"
end

Then /^the computer prints "(.*?)"$/ do |arg1|
#  @game.should_receive(:puts).with(arg1)
  expect(@game).to receive(:puts).with(arg1)
  @game.indicate_player_turn
end

Then /^waits for my input of "(.*?)"$/ do |arg1|
#  @game.should_receive(:gets).and_return(arg1)
  expect(@game).to receive(:gets).and_return(arg1)
  @game.get_player_move
end

Given /^it is the computer's turn$/ do
  @game = TicTacToe.new(:computer, :O)
  @game.current_player.expect eq "Computer"
end

Then /^the computer randomly chooses an open position for its move$/ do
  open_spots = @game.open_spots
  @com_move = @game.computer_move
  open_spots.expect include(@com_move)
end

Given /^the computer is playing X$/ do
  @game.computer_symbol.expect eq :X
end

Then /^the board should have an X on it$/ do
  @game.current_state.expect include 'X'
end

Given /^I am playing X$/ do
  @game = TicTacToe.new(:computer, :X)
  @game.player_symbol.expect eq :X
end

When /^I enter a position "(.*?)" on the board$/ do |arg1|
  @old_pos = @game.board[arg1.to_sym]
#  @game.should_receive(:get_player_move).and_return(arg1)
  expect(@game).to receive(:get_player_move).and_return(arg1)
  @game.player_move.expect eq arg1.to_sym
end

When /^"(.*?)" is not taken$/ do |arg1|
#  @old_pos.should eq " "
  expect(@old_pos).to eq(" ")
end

Then /^it is now the computer's turn$/ do
  @game.current_player.expect eq "Computer"
end

When /^there are three X's in a row$/ do
  @game = TicTacToe.new(:computer, :X)
  @game.board[:C1] = @game.board[:B2] = @game.board[:A3] = :X
end

Then /^I am declared the winner$/ do
  @game.determine_winner
  @game.player_won?.expect be_true
end

Then /^the game ends$/ do
  @game.over?.expect be_true
end

Given /^there are not three symbols in a row$/ do
  @game.board = {
      :A1 => :X, :A2 => :O, :A3 => :X,
      :B1 => :X, :B2 => :O, :B3 => :X,
      :C1 => :O, :C2 => :X, :C3 => :O
    }
    @game.determine_winner
end

When /^there are no open spaces left on the board$/ do
  @game.spots_open?.expect be_false
end

Then /^the game is declared a draw$/ do
  @game.draw?.expect be_true
end

When /^"(.*?)" is taken$/ do |arg1|
  @game.board[arg1.to_sym] = :O
  @taken_spot = arg1.to_sym
end

Then /^computer should ask me for another position "(.*?)"$/ do |arg1|
  @game.board[arg1.to_sym] = ' '
#  @game.should_receive(:get_player_move).twice.and_return(@taken_spot, arg1)
  expect(@game).to receive(:get_player_move).twice.and_return(@taken_spot, arg1)
  @game.player_move.expect eq arg1.to_sym
end
