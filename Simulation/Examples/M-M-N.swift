//
//  M-M-N.swift
//  Simulation
//
//  Created by Osmar Hernández on 23/11/19.
//  Copyright © 2019 personal. All rights reserved.
//

import Foundation

class NProcessorSimulation {
    // MARK: - Properties
    
    private let infinity: Double = 1_000_000_000.00
    
    private (set) var ea: Double                                // Expected Inter Arrival Time
    private (set) var es: Double                                // Expected Service Time
    private (set) var simulationTime: Double                    // Simulation Time (minutes)
    private (set) var resources: Int                            // Processors
    
    private var t: Double = 0.00                                // Time (also, it always has the time of the previous event)
    private var tAE: Double = 0.00                              // Time Arrival Event
    private var tDE: [Double]  = []                             // Time Departure Event -> Changes to an array of processors
    private var n: Int = 0                                      // Jobs In The System?
    private var b: [Double] = []                                // Busy Time -> Changes to an array
    private var c: Int = 0                                      // Completed Task
    private var s: Double = 0.00                                // Used to compute the number of jobs in the system
    private var k: Int = 0                                      // Current Processor
    
    // MARK: - Initializers
    
    // Default init
    init() {
        self.ea = 4.3
        self.es = 3.4
        self.simulationTime = 1_000.00
        self.resources = 2
        
        self.tDE = Array<Double>(repeating: infinity, count: resources)
        self.b = Array<Double>(repeating: 0.0, count: resources)
    }
    
    // Custom init
    init(expectedArrivalTime ea: Double, expectedServiceTime es: Double, simulationTime: Double, resources: Int) {
        self.ea = ea
        self.es = es
        self.simulationTime = simulationTime
        self.resources = resources
        
        self.tDE = Array<Double>(repeating: infinity, count: resources)
        self.b = Array<Double>(repeating: 0.0, count: resources)
    }
    
    // Custom simulation time init
    init(simulationTime: Double, resources: Int) {
        self.ea = 4.3
        self.es = 3.4
        self.resources = resources
        self.simulationTime = simulationTime
        
        self.tDE = Array<Double>(repeating: infinity, count: resources)
        self.b = Array<Double>(repeating: 0.0, count: resources)
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
            for idx in tDE.indices {
                if tDE[idx] == infinity {
                    k = idx
                }
            }
            
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
                    tDE[k] = self.infinity
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
        var U: [Double] = Array<Double>(repeating: 0, count: resources)
        
        for idx in U.indices {
            U[idx] = b[idx] / t
        }
        
        let N: Double = s / t
        let R: Double = es / (1 - ((U.reduce(0) { $0 + $1}) / Double(resources)) )
        let X: Double = Double(c) / t
        
        print("Average No. Jobs: \(N)")
        print("Utilization: \(U.reduce(0) { $0 + $1})")
        print("Residence Time: \(R)")
        print("Throughput: \(X)")
    }
}
