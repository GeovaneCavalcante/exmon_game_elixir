defmodule ExMon.GameTest do
  use ExUnit.Case

  alias ExMon.{Game, Player}

  describe "start/2" do
    test "starts the game state" do
      player = Player.build("Geovane", :chute, :soco, :cura)
      computer = Player.build("Robotinik", :chute, :soco, :cura)

      assert {:ok, _pid} = Game.start(computer, player)
    end
  end

  describe "info/0" do
    test "returns the current game state" do
      player = Player.build("Geovane", :chute, :soco, :cura)
      computer = Player.build("Robotinik", :chute, :soco, :cura)
      Game.start(computer, player)

      expected_response = %{
        status: :started,
        player: %Player{
          name: "Geovane",
          moves: %{move_heal: :cura, move_avg: :soco, move_rnd: :chute},
          life: 100
        },
        computer: %Player{
          name: "Robotinik",
          moves: %{move_heal: :cura, move_avg: :soco, move_rnd: :chute},
          life: 100
        },
        turn: :player
      }

      assert Game.info() == expected_response
    end
  end

  describe "update/1" do
    test "returns the game state updated" do
      player = Player.build("Geovane", :chute, :soco, :cura)
      computer = Player.build("Robotinik", :chute, :soco, :cura)
      Game.start(computer, player)

      expected_response = %{
        status: :started,
        player: %Player{
          name: "Geovane",
          moves: %{move_heal: :cura, move_avg: :soco, move_rnd: :chute},
          life: 100
        },
        computer: %Player{
          name: "Robotinik",
          moves: %{move_heal: :cura, move_avg: :soco, move_rnd: :chute},
          life: 100
        },
        turn: :player
      }

      assert Game.info() == expected_response

      new_state = %{
        status: :started,
        player: %Player{
          name: "Geovane",
          moves: %{move_heal: :cura, move_avg: :soco, move_rnd: :chute},
          life: 50
        },
        computer: %Player{
          name: "Robotinik",
          moves: %{move_heal: :cura, move_avg: :soco, move_rnd: :chute},
          life: 85
        },
        turn: :player
      }

      Game.update(new_state)

      expected_response = %{
        computer: %ExMon.Player{
          life: 85,
          moves: %{move_avg: :soco, move_heal: :cura, move_rnd: :chute},
          name: "Robotinik"
        },
        player: %ExMon.Player{
          life: 50,
          moves: %{move_avg: :soco, move_heal: :cura, move_rnd: :chute},
          name: "Geovane"
        },
        status: :continue,
        turn: :computer
      }

      assert Game.info() == expected_response
    end
  end
end
