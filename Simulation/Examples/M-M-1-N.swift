//
//  M-M-1-N.swift
//  Simulation
//
//  Created by Osmar Hernández on 23/11/19.
//  Copyright © 2019 personal. All rights reserved.
//

import Foundation

class LimitedCapacitySimulation {
    
    // MARK: - Properties
    
    private let infinity: Double = 1_000_000_000.00
    
    private (set) var ea: Double                              // Expected Inter Arrival Time
    private (set) var es: Double                              // Expected Service Time
    private (set) var simulationTime: Double                  // Simulation Time (minutes)
    private (set) var maxCapacity: Int                        // Limited Capacity
    
    private var t: Double = 0.00                              // Time (also, it always has the time of the previous event)
    private var tAE: Double = 0.00                            // Time Arrival Event
    private var tDE: Double = 0.00                            // Time Departure Event (infinity because we don't know when it will end)
    private var n: Int = 0                                    // Jobs In The System?
    private var b: Double = 0.00                              // Busy Time
    private var c: Int = 0                                    // Completed Task
    private var s: Double = 0.00                              // Used to compute the number of jobs in the system
    
    private var rjJ: Int = 0                                  // Rejected Jobs
    private var ttJ: Int = 0                                  // Total Jobs
    
    // MARK: - Initializers
    
    // Default init
    init() {
        self.ea = 4.3
        self.es = 3.4
        self.simulationTime = 1_000.00
        
        self.tDE = self.infinity
        self.maxCapacity = 8
    }
    
    // Custom init
    init(expectedArrivalTime ea: Double, expectedServiceTime es: Double, simulationTime: Double, maxCapacity: Int) {
        self.ea = ea
        self.es = es
        self.simulationTime = simulationTime
        self.maxCapacity = maxCapacity
        
        self.tDE = self.infinity
    }
    
    // Custom simulation time init
    init(simulationTime: Double, maxCapacity: Int) {
        self.ea = 4.3
        self.es = 3.4
        self.simulationTime = simulationTime
        self.maxCapacity = maxCapacity
        
        self.tDE = self.infinity
    }
    
    // MARK: - Methods
    
    /**
     * Every time we have an arrival we need to check if we can accept it or not
     * In case the job is rejected, generate the next arrival and calculate the total
     * of jobs and total of rejected jobs (probability).
     *
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
            ttJ += 1
            if tAE < tDE {
                // Arrival
                if n >= maxCapacity {
                    // Reject Arrival
                    rjJ += 1
                    
                    let z = -ea * log(Double.random(in: 0...1))
                    tAE = t + z
                } else {
                    // Accept Arrival
                    let dT = tAE - t
                    s += dT * Double(n)
                    t = tAE
                    n += 1
                    
                    var z = -ea * log(Double.random(in: 0...1))
                    tAE = t + z
                    
                    if n == 1 {
                        z = -es * log(Double.random(in: 0...1))
                        b += z
                        tDE = t + z
                        c += 1
                    }
                    
                    //print("Arrival time = \(t), job = \(n)")
                }
            } else {
                // Departure
                let dT = tDE - t
                s += dT * Double(n)
                n -= 1
                t = tDE
                
                if n >= 1 {
                    let z = -es * log(Double.random(in: 0...1))
                    b += z
                    tDE = t + z
                    c += 1
                } else {
                    tDE = self.infinity
                }
                
                //print("Departure time = \(t), job = \(n)")
            }
        }
    }
    
    /**
     * Utilization: Busy time / Observation Time
     * Throughput: Completed Task / Observation Time
     * Residence Time (Little Law): Service Time / (1 - Utilization)
     */
    func nurx() {
        let N = s / t
        let U = b / t
        let R = es / (1 - U)
        let X = Double(c) / t
        let probRej = Double(rjJ) / Double(ttJ)
        
        print("Average No. Jobs: \(N)")
        print("Utilization: \(U)")
        print("Residence Time:  \(R/Double(ttJ))")
        print("Throughput: \(X)")
        print("Probability of Rejection: \(probRej)")
    }
}
