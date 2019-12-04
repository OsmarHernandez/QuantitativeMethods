//
//  main.swift
//  Simulation
//
//  Created by Osmar Hernández on 20/11/19.
//  Copyright © 2019 personal. All rights reserved.
//

import Foundation

let finalProject = OneProcessorSimulation(expectedArrivalTime: 1/30, expectedServiceTime: 1/1000, simulationTime: 100_000)

finalProject.start()
finalProject.nurx()
