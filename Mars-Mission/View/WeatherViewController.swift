//
//  WeatherViewController.swift
//  Mars-Mission
//
//  Created by Thotsana Mabotsa on 2020/11/23.
//

import UIKit

class WeatherViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, WeatherView {
	
	
	@IBOutlet weak var detailsLabel: UILabel!
	@IBOutlet weak var tableView: UITableView!
	@IBOutlet weak var activityIndicator: UIActivityIndicatorView!
	
	private lazy var viewModel = WeatherViewModel(view: self)
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		viewModel.fetchForecast()
		
		tableView.dataSource = self
		tableView.delegate = self
		let nibName = UINib(nibName: "TableViewCell", bundle: nil)
		tableView.register(nibName, forCellReuseIdentifier: "tableViewCell")
		navigationItem.title = "NASA Weather"
//		self.detailsLabel.text = "Weather details over the past 6 days"
	}
	
	func showLoadingIndicator() {
		self.activityIndicator.startAnimating()
		self.activityIndicator.isHidden = false
	}
	
	func hideLoadingIndicator() {
		self.activityIndicator.stopAnimating()
		self.activityIndicator.isHidden = true
	}
	
	func reloadWeatherTableView() {
		self.tableView.reloadData()
	}
	func showServerError() {
		let alert = UIAlertController(title: "Oops..!", message: "It looks like the server is not reachable,\nplease try again later.", preferredStyle: UIAlertController.Style.alert)
		self.present(alert, animated: true, completion: nil)
		alert.addAction(UIAlertAction(title: "Dismis", style: .cancel, handler: {_ in 
			self.hideLoadingIndicator()
		}))
		alert.addAction(UIAlertAction(title: "Retry", style: .default, handler: {_ in
			self.viewModel.fetchForecast()
		}))
	}
}

extension WeatherViewController {
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		viewModel.forecastDetails?.count ?? 0
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "tableViewCell", for: indexPath) as! TableViewCell
		tableView.separatorStyle = .none
				
		cell.commonInit(date: "\(String(describing: viewModel.forecastDetails?[indexPath.row].date ?? ""))")
		return cell
	}
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		100
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let vc = WeatherDetailsViewController()
		vc.commonInit(date: "Date: \(convertUTCDateToLocalDate(date: viewModel.forecastDetails?[indexPath.row].date ?? "") )",
					  temp: "Temp: \(viewModel.forecastDetails?[indexPath.row].temp ?? 0) ℃",
					  humidity: " Humidity: \(viewModel.forecastDetails?[indexPath.row].humidity ?? 0) ％",
					  windSpeed: "WindSpeed: \(viewModel.forecastDetails?[indexPath.row].windSpeed ?? 0) km/h",
					  safe: "Safe: \(viewModel.forecastDetails?[indexPath.row].safe ?? false)")
		self.navigationController?.pushViewController(vc, animated: true)
		tableView.deselectRow(at: indexPath, animated: true)
	}
}
