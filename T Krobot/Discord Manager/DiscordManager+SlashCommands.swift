//
//  DiscordManager+SlashCommands.swift
//  T Krobot
//
//  Created by Jia Chen Yee on 19/3/23.
//

import Foundation
import DiscordBM

extension DiscordManager {
    func configureCommands() async {
        for manager in slashCommandManagers {
            let slashCommand = manager.slashCommand
            
            // swiftlint:disable force_try
            let result = try! await bot.client.createGlobalApplicationCommand(payload: slashCommand)
            
            print(result.httpResponse)
        }
    }
    
    func handleIncomingSlashCommand(_ command: Interaction.ApplicationCommand,
                                    interaction: Interaction) {
        Task {
            if let targetManager = slashCommandManagers.first(where: { $0.name == command.name }) {
                try await targetManager.handleInteraction(interaction)
            }
        }
    }
    
    func purgeAllCommands() async throws {
        let commands = try await bot.client.getGlobalApplicationCommands().decode()
        for command in commands {
            _ = try await bot.client.deleteGlobalApplicationCommand(commandId: command.id)
        }
    }
}
