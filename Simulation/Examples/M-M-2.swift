//
//  M-M-2.swift
//  Simulation
//
//  Created by Osmar Hernández on 23/11/19.
//  Copyright © 2019 personal. All rights reserved.
//

import Foundation

class TwoProcessorSimulation {
    
    // MARK: - Properties
    
    private (set) var ea: Double                                    // Expected Inter Arrival Time
    private (set) var es: Double                                    // Expected Service Time
    private (set) var simulationTime: Double                        // Simulation Time (minutes)
    
    private var t: Double = 0.00                                    // Time (also, it always has the time of the previous event)
    private var tAE: Double = 0.00                                  // Time Arrival Event
    private var tDE: [Double] = [Double.infinity, Double.infinity]  // Time Departure Event -> Changes to an array of processors
    private var n: Int = 0                                          // Jobs In The System?
    private var b: [Double] = [0.00, 0.00]                          // Busy Time -> Changes to an array
    private var c: Int = 0                                          // Completed Task
    private var s: Double = 0.00                                    // Used to compute the number of jobs in the system
    private var k: Int = 0                                          // Current Processor
    
    // MARK: - Initializers
    
    // Default init
    init() {
        self.ea = 4.3
        self.es = 3.4
        self.simulationTime = 1_000.00
    }
    
    // Custom init
    init(expectedArrivalTime ea: Double, expectedServiceTime es: Double, simulationTime: Double) {
        self.ea = ea
        self.es = es
        self.simulationTime = simulationTime
    }
    
    // Custom simulation time init
    init(simulationTime: Double) {
        self.ea = 4.3
        self.es = 3.4
        self.simulationTime = simulationTime
    }
    
    // MARK: - Methods
    
    /**
     * Arrival:
     * Update state
     * Update time
     * Generate next arrival time
     * If the system was empty, generate departure time
     * Departure:
     * Update state
     * Update time
     * Generate next arrival time
     * If the system is not empty, generate next departure
     * If the system is empty, put next departure to infinity
     */
    func start() {
        while t < simulationTime {
            k = tDE[0] == Double.infinity ? 0 : 1
            
            if tAE < tDE[k] {
                // Arrival
                let dT = tAE - t
                s += dT * Double(n)
                n += 1
                t = tAE
                
                var z = -ea * log(Double.random(in: 0...1))
                tAE = t + z
                
                if n <= 2 {
                    z = -es * log(Double.random(in: 0...1))
                    b[k] += z
                    tDE[k] = t + z
                }
                
                //print("Arrival time = \(t), Processor = \(k), job = \(n)")
            } else {
                // Departure
                let dT = tDE[k] - t
                s += dT * Double(n)
                n -= 1
                c += 1
                t = tDE[k]
                
                if n <= 1 {
                    tDE[k] = Double.infinity
                } else {
                    let z = -es * log(Double.random(in: 0...1))
                    b[k] += z
                    tDE[k] = t + z
                }
                
                //print("Departure time = \(t), Processor = \(k), job = \(n)")
            }
        }
    }
    
    /**
     * Utilization: Busy time / Observation Time -> Changes to an array
     * Throughput: Completed Task / Observation Time
     * Residence Time (Little Law): Service Time / (1 - Utilization)
     */
    func nurx() {
        var U: [Double] = [0.00, 0.00]
        U[0] = b[0] / t
        U[1] = b[1] / t
        
        let N: Double = s / t
        let R: Double = es / (1 - ((U[0] + U[1]) / 2))
        let X: Double = Double(c) / t
        
        print("Average No. Jobs: \(N)")
        print("Utilization P[0]: \(U[0]) . Utilization P[1]: \(U[1])")
        print("Residence Time: \(R)")
        print("Throughput: \(X)")
    }
}
